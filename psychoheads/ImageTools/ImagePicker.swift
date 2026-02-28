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

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        // Prefer images at highest fidelity the picker can provide
        config.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            defer {
                DispatchQueue.main.async {
                    self.parent.isPickerShowing = false
                }
            }

            guard let itemProvider = results.first?.itemProvider else { return }

            // 1) Best: load a file representation (often the original HEIC/JPEG)
            let utType = UTType.image.identifier
            if itemProvider.hasItemConformingToTypeIdentifier(utType) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: utType) { url, error in
                    if let error {
                        print("PHPicker: loadFileRepresentation error:", error)
                    }

                    if let url {
                        do {
                            // url is temporary; copy/read immediately (full-resolution file from Photos)
                            let data = try Data(contentsOf: url)
                            if let img = UIImage(data: data) {
                                DispatchQueue.main.async { self.parent.selectedImage = img }
                                return
                            } else {
                                print("PHPicker: failed to decode image from file data")
                            }
                        } catch {
                            print("PHPicker: Data(contentsOf:) failed:", error)
                        }
                    }

                    // 2) Fallback: load data representation
                    self.loadViaDataRepresentation(itemProvider: itemProvider)
                }
                return
            }

            // 3) Last fallback: data representation
            loadViaDataRepresentation(itemProvider: itemProvider)
        }

        private func loadViaDataRepresentation(itemProvider: NSItemProvider) {
            let utType = UTType.image.identifier
            itemProvider.loadDataRepresentation(forTypeIdentifier: utType) { data, error in
                if let error {
                    print("PHPicker: loadDataRepresentation error:", error)
                }
                guard let data, let img = UIImage(data: data) else {
                    print("PHPicker: failed to decode image from dataRepresentation")
                    return
                }
                DispatchQueue.main.async { self.parent.selectedImage = img }
            }
        }
    }
}
