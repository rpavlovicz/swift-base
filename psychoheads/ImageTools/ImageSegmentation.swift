//
//  ImageSegmentation.swift
//  psychoheads
//
//  Uses Vision framework VNGenerateForegroundInstanceMaskRequest (iOS 17+)
//  for subject/foreground segmentation and background removal.
//

import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import CoreVideo

enum ImageSegmentationError: Error {
    case unsupportedOS
    case invalidInput
    case maskGenerationFailed
    case renderFailed
}

@available(iOS 17.0, *)
enum ImageSegmentation {

    private static let ciContext: CIContext = {
        CIContext(options: [.useSoftwareRenderer: false])
    }()

    /// Removes the background from the given image; returns a new image with transparent background,
    /// cropped to the chosen subject instance (largest by mask area).
    /// Runs on a background thread. Requires a physical device (does not work in Simulator).
    static func removeBackground(from image: UIImage) async throws -> UIImage {
        return try await Task.detached(priority: .userInitiated) {
            guard let inputCIImage = ciImage(from: image) else {
                throw ImageSegmentationError.invalidInput
            }

            // --- Vision request
            let handler = VNImageRequestHandler(ciImage: inputCIImage, options: [:])
            let request = VNGenerateForegroundInstanceMaskRequest()
            try handler.perform([request])

            guard let observation = request.results?.first else {
                throw ImageSegmentationError.maskGenerationFailed
            }

            let instances = observation.allInstances
            guard !instances.isEmpty else {
                throw ImageSegmentationError.maskGenerationFailed
            }

            // --- Pick the "main" instance (largest foreground area in scaled mask)
            guard let bestInstance = chooseLargestInstance(observation: observation, handler: handler) else {
                throw ImageSegmentationError.maskGenerationFailed
            }

            // --- Generate a scaled mask for the chosen instance (fast bbox + full-res crop mapping)
            let maskBuffer = try observation.generateScaledMaskForImage(forInstances: IndexSet(integer: bestInstance), from: handler)

            // --- Compute bbox in mask space (top-left origin)
            let bboxMask = boundingRectOfForeground(in: maskBuffer)

            // --- Map bbox from mask coords -> CI coords (bottom-left origin, full-res)
            let imageExtent = inputCIImage.extent
            let maskW = CGFloat(CVPixelBufferGetWidth(maskBuffer))
            let maskH = CGFloat(CVPixelBufferGetHeight(maskBuffer))

            let scaleX = imageExtent.width / maskW
            let scaleY = imageExtent.height / maskH

            // bboxMask is in mask space with origin at top-left, y increasing downward.
            // Convert to CI/image space (origin bottom-left).
            let cropRectCI = CGRect(
                x: imageExtent.minX + bboxMask.minX * scaleX,
                y: imageExtent.minY + (imageExtent.height - (bboxMask.maxY * scaleY)),
                width: bboxMask.width * scaleX,
                height: bboxMask.height * scaleY
            ).integral

            // --- Generate a full-frame masked image for ONLY the chosen instance
            // croppedToInstancesExtent: false so we keep full-frame and use our own crop rect.
            let maskedBuffer = try observation.generateMaskedImage(
                ofInstances: IndexSet(integer: bestInstance),
                from: handler,
                croppedToInstancesExtent: false
            )

            // --- Crop and render
            let maskedCI = CIImage(cvPixelBuffer: maskedBuffer)

            // Protect against weird extents (should be full frame)
            let finalCrop = cropRectCI.intersection(maskedCI.extent).integral
            guard finalCrop.width > 0, finalCrop.height > 0 else {
                throw ImageSegmentationError.renderFailed
            }

            let cropped = maskedCI.cropped(to: finalCrop)
            guard let out = renderToUIImage(cropped, extent: finalCrop, scale: 1.0, orientation: .up) else {
                throw ImageSegmentationError.renderFailed
            }

            return out
        }.value
    }

    // MARK: - Private helpers

    private static func ciImage(from image: UIImage) -> CIImage? {
        guard let cgImage = image.cgImage else { return nil }
        let ci = CIImage(cgImage: cgImage)
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        return ci.oriented(orientation)
    }

    /// Choose the instance with the largest foreground area by generating a scaled mask per instance.
    private static func chooseLargestInstance(observation: VNInstanceMaskObservation,
                                             handler: VNImageRequestHandler) -> Int? {
        var best: Int?
        var bestArea: Int = -1

        for inst in observation.allInstances {
            guard let buf = try? observation.generateScaledMaskForImage(forInstances: IndexSet(integer: inst), from: handler) else {
                continue
            }
            let area = foregroundArea(in: buf)

            if area > bestArea {
                bestArea = area
                best = inst
            }
        }

        return best
    }

    /// Count foreground pixels above a threshold in a mask buffer.
    /// Supports OneComponent8 and OneComponent32Float.
    private static func foregroundArea(in maskBuffer: CVPixelBuffer) -> Int {
        let width = CVPixelBufferGetWidth(maskBuffer)
        let height = CVPixelBufferGetHeight(maskBuffer)
        let format = CVPixelBufferGetPixelFormatType(maskBuffer)

        CVPixelBufferLockBaseAddress(maskBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(maskBuffer, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(maskBuffer) else { return 0 }
        let bpr = CVPixelBufferGetBytesPerRow(maskBuffer)

        var count = 0

        if format == kCVPixelFormatType_OneComponent8 {
            let threshold: UInt8 = 10
            for y in 0..<height {
                let row = base.advanced(by: y * bpr).assumingMemoryBound(to: UInt8.self)
                for x in 0..<width {
                    if row[x] >= threshold { count += 1 }
                }
            }
        } else if format == kCVPixelFormatType_OneComponent32Float {
            for y in 0..<height {
                let row = base.advanced(by: y * bpr).assumingMemoryBound(to: Float.self)
                for x in 0..<width {
                    if row[x] > 0.5 { count += 1 }
                }
            }
        }

        return count
    }

    /// Returns the bounding rect of foreground pixels in the mask, in buffer coordinate space
    /// with origin at top-left (y increases downward).
    private static func boundingRectOfForeground(in maskBuffer: CVPixelBuffer) -> CGRect {
        let width = CVPixelBufferGetWidth(maskBuffer)
        let height = CVPixelBufferGetHeight(maskBuffer)
        let format = CVPixelBufferGetPixelFormatType(maskBuffer)
        let fullExtent = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))

        CVPixelBufferLockBaseAddress(maskBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(maskBuffer, .readOnly) }
        guard let baseAddress = CVPixelBufferGetBaseAddress(maskBuffer) else {
            return fullExtent
        }
        let bytesPerRow = CVPixelBufferGetBytesPerRow(maskBuffer)

        var minX = width
        var minY = height
        var maxX = 0
        var maxY = 0

        if format == kCVPixelFormatType_OneComponent8 {
            let threshold: UInt8 = 10
            for y in 0..<height {
                let row = baseAddress.advanced(by: y * bytesPerRow).assumingMemoryBound(to: UInt8.self)
                for x in 0..<width {
                    if row[x] >= threshold {
                        minX = min(minX, x)
                        minY = min(minY, y)
                        maxX = max(maxX, x)
                        maxY = max(maxY, y)
                    }
                }
            }
        } else if format == kCVPixelFormatType_OneComponent32Float {
            for y in 0..<height {
                let row = baseAddress.advanced(by: y * bytesPerRow).assumingMemoryBound(to: Float.self)
                for x in 0..<width {
                    if row[x] > 0.5 {
                        minX = min(minX, x)
                        minY = min(minY, y)
                        maxX = max(maxX, x)
                        maxY = max(maxY, y)
                    }
                }
            }
        } else {
            return fullExtent
        }

        if minX > maxX || minY > maxY {
            return fullExtent
        }

        return CGRect(
            x: CGFloat(minX),
            y: CGFloat(minY),
            width: CGFloat(maxX - minX + 1),
            height: CGFloat(maxY - minY + 1)
        )
    }

    private static func renderToUIImage(_ ciImage: CIImage,
                                        extent: CGRect,
                                        scale: CGFloat,
                                        orientation: UIImage.Orientation) -> UIImage? {
        let renderExtent = extent.intersection(ciImage.extent)
        guard renderExtent.width > 0, renderExtent.height > 0,
              let cgImage = ciContext.createCGImage(ciImage, from: renderExtent) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }
}

// MARK: - Orientation conversion

private extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
