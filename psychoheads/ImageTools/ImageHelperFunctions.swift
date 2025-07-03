//
//  ImageHelperFunctions.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/25/25.
//


//
//  ImageHelperFunctions.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/27/23.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Combine

struct ImageHelperFunctions {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func uploadSourceImages(image: UIImage, docName: String) {
        
        let imagePath = "sourceImages/\(docName).png"
        let thumbPath = "sourceImages/\(docName)_thumb.png"
        let midsizedPath = "sourceImages/\(docName)_mid.png"
        
        // Original image upload
        uploadImage(image: image, imagePath: imagePath)
        
        // Thumbnail image upload
        let downscaleSize = CGSize(width: 150.0, height: 150.0)
        if let scaledImage = self.resizeImage(image: image, targetSize: downscaleSize) {
            uploadImage(image: scaledImage, imagePath: thumbPath)
        }
        
        // Midsize image upload
        let downscaleMid = CGSize(width: 500.0, height: 500.0)
        if let scaledImageMid = self.resizeImage(image: image, targetSize: downscaleMid) {
            uploadImage(image: scaledImageMid, imagePath: midsizedPath)
        }
    }
    
    func uploadClippingImages(image: UIImage, docName: String) {
        
        let imagePath = "clippingImages/\(docName).png"
        let thumbPath = "clippingImages/\(docName)_thumb.png"
        let midsizedPath = "clippingImages/\(docName)_mid.png"
        
        // Original image upload
        uploadImage(image: image, imagePath: imagePath)
        
        // Thumbnail image upload
        let downscaleSize = CGSize(width: 150.0, height: 150.0)
        if let scaledImage = self.resizeImage(image: image, targetSize: downscaleSize) {
            uploadImage(image: scaledImage, imagePath: thumbPath)
        }
        
        // Midsize image upload
        let downscaleMid = CGSize(width: 500.0, height: 500.0)
        if let scaledImageMid = self.resizeImage(image: image, targetSize: downscaleMid) {
            uploadImage(image: scaledImageMid, imagePath: midsizedPath)
        }
    }
    
    func uploadImage(image: UIImage, imagePath: String) {
        let storageRef = Storage.storage().reference()
        
        if let pngData = image.pngData() {
//            let pngSize = Double(pngData.count) / (1024.0 * 1024.0)
//            print("original png size = \(String(format: "%.2f", pngSize)) MB")
//            print("original image width x height = \(image!.size.width) x \(image!.size.height)")
            let fileRef = storageRef.child(imagePath)
            let uploadTask = fileRef.putData(pngData, metadata: nil) { metadata, error in
                if error == nil && metadata != nil {
                    print("Successfully uploaded image to \(imagePath)")
                } else {
                    print("Error uploading image to \(imagePath): \(String(describing: error))")
                }
            }
        } else {
            print("Error converting image to data for \(imagePath)")
        }
    }
    
    func flipImageVertically(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        
        image.draw(at: CGPoint.zero)
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
    
    func flipImageVerticallyAndHorizontally(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Translate and scale the context to flip both vertically and horizontally
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.scaleBy(x: -1.0, y: -1.0)
        context.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        
        image.draw(at: CGPoint.zero)
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
 
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var dbFuncs = dbFunctions()
    private var cancellable: AnyCancellable?
    
    func load(imagePath: String, useCache: Bool = false, completion: @escaping (Bool, UIImage?) -> Void) {
        let key = extractKeyFromImagePath(imagePath)
        
        if useCache {
            if let cachedImage = CacheManager.shared.getCachedImage(forKey: key) {
                self.image = cachedImage
                completion(true, cachedImage)
                return
            }
        }
        
        if let existingImage = image {
            // If the image is already downloaded and cached, no need to download again
            completion(true, existingImage)
            return
        }

        // Download and cache the image
        cancellable = dbFuncs.getThumbnail(imagePath: imagePath)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionStatus in
                           if case .failure(_) = completionStatus {
                               print("could not download image from \(imagePath)")
                               print("using 'broken_image_link' system image instead")
                               self?.image = UIImage(named: "broken_image_link")
                               completion(false, self?.image)
                           }
                       }, receiveValue: { [weak self] downloadedImage in
                           if useCache {
                               CacheManager.shared.cacheImage(image: downloadedImage, forKey: key)
                           }
                           self?.image = downloadedImage
                           completion(true, downloadedImage)
                       })
    } // load function
    
    func extractKeyFromImagePath(_ imagePath: String) -> String {
        // Assuming the imagePath format is always "sourceImages/<UUID>_thumb.png"
        // This will extract the filename without extension
        let key = imagePath.components(separatedBy: "/").last?.split(separator: ".").first ?? ""
        return String(key)
    }

}

struct AsyncImage1: View {
    @StateObject private var imageLoader = ImageLoader()
    var clipping: Clipping
    var placeholder: UIImage
    
    var body: some View {
        ZStack {
            if clipping.imageThumb != nil {
                Image(uiImage: clipping.imageThumb!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            } else {
                    Image(uiImage: placeholder)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
            }
        }
        .onAppear {
            if clipping.imageThumb == nil {
                print("thumbnail not found for \(clipping.id)")
                print("trying to load from \(clipping.imageUrlThumb)")
                
                if clipping.imageUrlThumb == "" {
                    print("****thumbnail url is an empty string!")
                    clipping.imageThumb = UIImage(named: "broken_image_link")
                }
                imageLoader.load(imagePath: clipping.imageUrlThumb, useCache: true) { success, downloadedImage in
                    if success, let validImage = downloadedImage {
                        clipping.imageThumb = downloadedImage
                    } else {
                        clipping.imageThumb = UIImage(named: "broken_image_link")
                    }
                    
                }
            }
        }
    }
}

struct AsyncImage2: View {
    @StateObject private var imageLoader = ImageLoader()
    //var clipping: Clipping
    @ObservedObject var clipping: Clipping
    var placeholder: UIImage
    var imageUrlMid: String
    var frameHeight: CGFloat
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: frameHeight)
            } else {
                Image(uiImage: placeholder)
                    .resizable()
                    .scaledToFit()
                    .frame(height: frameHeight)
            }
        }
        .onAppear {
            loadImage(url: imageUrlMid)
        }
        .onChange(of: clipping.imageUrlMid) { newValue in
            print("detected change of clipping.imageUrlMid")
            print("new url: \(newValue)")
            imageLoader.image = nil // ** this is key to getting the view to refresh!
            loadImage(url: newValue)
        }
    } // View
    
    private func loadImage(url: String) {
        imageLoader.load(imagePath: url, useCache: true) { success, downloadedImage in
            if success, let validImage = downloadedImage {
                DispatchQueue.main.async {
                    clipping.imageMid = validImage
                    imageLoader.image = validImage
                    print("successful loading of imageUrlMid")
                    print("url: \(url)")
                }
            }
        }
    }
}
