//
//  ImagePicker.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ImagePicker.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/21/23.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    var source: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    // create custom coorindator class for UIImagePickerController
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.isPickerShowing = false
    }
    
}
