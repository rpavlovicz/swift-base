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

import SwiftUI
import AVFoundation
import FirebaseFirestore

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ImageCaptureView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    @State private var selectedImage: UIImage? = nil
    //@State private var selectedImage: UIImage? = UIImage(named: "mag_1")
    @State var isPickerShowing: Bool = false
    
    @State var isSourceMenuShowing: Bool = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary

    @State var addDatabaseItemMenu: Bool = false
    @State var tabBinding = 1
    @State private var backgroundColorIndex = 0 // 0=green, 1=black, 2=white
    
    //@ObservedObject var bgRemover = RemoveBackground()
    private let imageHelper = ImageHelperFunctions()
    
    private var backgroundColor: Color {
        switch backgroundColorIndex {
        case 0:
            return .green
        case 1:
            return .white
        case 2:
            return .black
        default:
            return .green
        }
    }
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {

        VStack {
            
            if let image = selectedImage {
                //if bgRemover.outputImage != nil {
                //    Image(uiImage: bgRemover.outputImage!)
                //        .resizable()
                //        .scaledToFit()
                //        .padding(.top, 50)
                //} else {
                    ZStack {
                        backgroundColor
                            .edgesIgnoringSafeArea(.horizontal)
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .background(.clear)
                    }
                    .padding(.top, 50)
                //}
            } else {
                ImagePlaceholderView()
            }

            Spacer()
            
            ImageCaptureButtonRow(
                selectedImage: $selectedImage,
                isSourceMenuShowing: $isSourceMenuShowing,
                addDatabaseItemMenu: $addDatabaseItemMenu,
                tabBinding: $tabBinding,
                backgroundColorIndex: $backgroundColorIndex
            )
            .frame(maxWidth: .infinity, maxHeight: 40)
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .if(isPad) { view in
            view.sheet(isPresented: $isSourceMenuShowing) {
                VStack(spacing: 0) {
                    Button("Photo Library") {
                        self.source = .photoLibrary
                        isPickerShowing = true
                        isSourceMenuShowing = false
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .font(.title2)
                    
                    Divider()
                    
                    Button("Camera") {
                        self.source = .camera
                        isPickerShowing = true
                        isSourceMenuShowing = false
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .font(.title2)
                    
                    Button("Cancel") {
                        isSourceMenuShowing = false
                    }
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
                Button("Photo Library") {
                    self.source = .photoLibrary
                    isPickerShowing = true
                }
                Button("Camera") {
                    self.source = .camera
                    isPickerShowing = true
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: self.source)
        }
        .if(isPad) { view in
            view.presentationDetents([.large])
        }
    
    }

}

struct BackgroundBlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    
    }
    
}

struct BackgroundBlurView2: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        DispatchQueue.main.async {
            view.superview?.superview?.superview?.backgroundColor = .clear
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    
    }
    
}

struct ImageCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ImageCaptureView()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .previewDisplayName("Empty State")
        
        NavigationStack {
            ImageCaptureView()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .previewDisplayName("With Sample Image")
        .onAppear {
            // This would set a sample image if needed for preview
        }
    }
}
