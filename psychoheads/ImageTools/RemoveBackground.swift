////
////  RemoveBackground.swift
////  psychoheads
////
////  Created by Ryan Pavlovicz on 6/27/25.
////
//
//
////
////  RemoveBackground.swift
////  psychoheads
////
////  Created by Ryan Pavlovicz on 3/21/23.
////  uses old DeepLabV3 image segmenter which doesn't work so well
////
//
//import SwiftUI
//import CoreML
//import Vision
//
//class RemoveBackground : ObservableObject {
//    
//    private let model = try! VNCoreMLModel(for: DeepLabV3(configuration: MLModelConfiguration()).model)
//    var inputImage : UIImage = UIImage()
//    @Published var outputImage: UIImage?
//    
//    func testFunc() {
//        print("testFunc sees inputImage = \(inputImage)")
//        let ciImage = CIImage(image: inputImage)!.oriented(.right)
//        self.outputImage = UIImage(ciImage: ciImage)
//    }
//    
//    func segmentImage()
//    {
//        print("input image orientation = \(inputImage.imageOrientation.rawValue)")
//        let ciImage = CIImage(image: inputImage)!.oriented(inputImage.imageOrientation.rawValue == 3 ? .right : .up)
//        
//        var request : VNCoreMLRequest
//        request = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
//        request.imageCropAndScaleOption = .scaleFill
//        
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        DispatchQueue.global().async {
//            do {
//                try handler.perform([request])
//            } catch {
//                print("failed to perform image segmentation :\(error.localizedDescription)")
//            }
//        }
//        
//    }
//    
//    func visionRequestDidComplete(request: VNRequest, error: Error?)
//    {
//        DispatchQueue.main.async {
//            if let observation = request.results as? [VNCoreMLFeatureValueObservation],
//              let segmentationMap = observation.first?.featureValue.multiArrayValue {
//                let segmentationMask = segmentationMap.image(min: 0, max: 1)
//                
//                self.outputImage = segmentationMask!.resized(to: self.inputImage.size)
//                self.outputImage = self.maskInputImage()
//            }
//        }
//        
//    }
//    
//    func maskInputImage() -> UIImage {
//        let bgImage = UIImage.imageFromColor(color: .white, size: self.inputImage.size, scale: self.inputImage.scale)!
//        
//        let beginImage = CIImage(cgImage: inputImage.cgImage!).oriented(inputImage.imageOrientation.rawValue == 3 ? .right : .up)
//        let background = CIImage(cgImage: bgImage.cgImage!)
//        let mask = CIImage(cgImage: (self.outputImage?.cgImage!)!)
//        
//        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
//                                        kCIInputImageKey: beginImage,
//                                        kCIInputBackgroundImageKey: background,
//                                        kCIInputMaskImageKey: mask])?.outputImage {
//            let ciContext = CIContext(options: nil)
//            let filteredImageReference = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
//            
//            return UIImage(cgImage: filteredImageReference!)
//        }
//        
//        return UIImage()
//    }
//    
//}
//
//extension UIImage {
//    class func imageFromColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), scale: CGFloat) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        color.setFill()
//        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
