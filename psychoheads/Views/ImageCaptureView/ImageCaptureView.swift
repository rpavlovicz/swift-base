//
//  ImageCaptureView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ImageCaptureView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/11/23.
//

//
//  ImageCaptureView.swift
//  psychoheads
//
//  Uses:
//  - PHPicker-based ImagePicker (full-res library import)
//  - CameraPicker (UIImagePickerController camera only)
//

import SwiftUI
import AVFoundation
import FirebaseFirestore

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}

struct ImageCaptureView: View {

    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager

    @State private var selectedImage: UIImage? = nil
    @State private var segmentedImage: UIImage? = nil
    @State private var isSegmenting: Bool = false

    // Pickers
    @State private var isPhotoPickerShowing: Bool = false   // PHPicker (library)
    @State private var isCameraPickerShowing: Bool = false  // UIImagePickerController (camera)

    // UI state
    @State private var isSourceMenuShowing: Bool = false
    @State private var addDatabaseItemMenu: Bool = false
    @State private var tabBinding = 1
    @State private var backgroundColorIndex = 0 // 0=green, 1=white, 2=black

    private var displayImage: UIImage? { segmentedImage ?? selectedImage }
    private let imageHelper = ImageHelperFunctions()

    private var backgroundColor: Color {
        switch backgroundColorIndex {
        case 0: return .green
        case 1: return .white
        case 2: return .black
        default: return .green
        }
    }

    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        VStack {
            if let image = displayImage {
                ZStack {
                    backgroundColor
                        .edgesIgnoringSafeArea(.horizontal)

                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(.clear)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 50)
            } else {
                ImagePlaceholderView()
            }

            Spacer()

            ImageCaptureButtonRow(
                selectedImage: $selectedImage,
                displayImage: displayImage,
                isSourceMenuShowing: $isSourceMenuShowing,
                addDatabaseItemMenu: $addDatabaseItemMenu,
                tabBinding: $tabBinding,
                backgroundColorIndex: $backgroundColorIndex,
                isSegmenting: isSegmenting,
                onRemoveBackground: removeBackground
            )
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
        .navigationBarTitle("", displayMode: .inline)

        // Source menu UI
        .if(isPad) { view in
            view.sheet(isPresented: $isSourceMenuShowing) {
                VStack(spacing: 0) {
                    Button("Photo Library") {
                        isPhotoPickerShowing = true
                        isSourceMenuShowing = false
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .font(.title2)

                    Divider()

                    Button("Camera") {
                        isCameraPickerShowing = true
                        isSourceMenuShowing = false
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .font(.title2)

                    Button("Cancel") { isSourceMenuShowing = false }
                        .buttonStyle(.plain)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .font(.title2)
                        .background(.ultraThinMaterial)
                }
                .cornerRadius(8)
                .presentationDetents([.height(170)])
            }
            .background(.ultraThinMaterial)
        }
        .if(!isPad) { view in
            view.confirmationDialog("Select image source", isPresented: $isSourceMenuShowing) {
                Button("Photo Library") { isPhotoPickerShowing = true }
                Button("Camera") { isCameraPickerShowing = true }
                Button("Cancel", role: .cancel) {}
            }
        }

        // Reset segmentation when a new image is selected
        .onChange(of: selectedImage) { _, _ in
            segmentedImage = nil
        }

        // Library picker (PHPicker-based ImagePicker.swift)
        .sheet(isPresented: $isPhotoPickerShowing) {
            ImagePicker(
                selectedImage: $selectedImage,
                isPickerShowing: $isPhotoPickerShowing
            )
        }

        // Camera picker (camera-only)
        .sheet(isPresented: $isCameraPickerShowing) {
            CameraPicker(
                selectedImage: $selectedImage,
                isPickerShowing: $isCameraPickerShowing
            )
        }

        .if(isPad) { view in
            view.presentationDetents([.large])
        }
    }

    private func removeBackground() {
        guard let image = selectedImage else { return }
        guard #available(iOS 17.0, *) else { return }

        isSegmenting = true
        Task {
            do {
                let result = try await ImageSegmentation.removeBackground(from: image)
                await MainActor.run {
                    segmentedImage = result
                    isSegmenting = false
                }
            } catch {
                await MainActor.run { isSegmenting = false }
                print("ImageCaptureView: removeBackground failed – \(error)")
            }
        }
    }
}

//
// CameraPicker.swift (camera-only UIImagePickerController wrapper)
// Put this in its own file if you prefer.
//

import UIKit

struct CameraPicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPickerShowing = false
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.selectedImage = image
                    self.parent.isPickerShowing = false
                }
            } else {
                parent.isPickerShowing = false
            }
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        DispatchQueue.main.async { view.superview?.superview?.backgroundColor = .clear }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct BackgroundBlurView2: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        DispatchQueue.main.async { view.superview?.superview?.superview?.backgroundColor = .clear }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
