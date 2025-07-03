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
    
    //@ObservedObject var bgRemover = RemoveBackground()
    private let imageHelper = ImageHelperFunctions()
    
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
                        Color.green.edgesIgnoringSafeArea(.horizontal)
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .background(.clear)
                    }
                    .padding(.top, 50)
                //}
            } else {
                Rectangle()
                    .frame(width: 340, height: 550)
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .padding(.top, 50)
            }

            Spacer()
            
            HStack {
                // image selection button
                Button {
                    isSourceMenuShowing = true
                    
                } label: {
                    ZStack {
                        Image(systemName: "camera")
                            .font(Font.system(size: 20))
                        Image(systemName: "circle")
                            .font(Font.system(size: 50, weight: .light))
                    }
                }
                
                // image segmentation button
                
                // Button {
                   
                //     if selectedImage != nil &&
                //         bgRemover.outputImage == nil {
                        
                //         bgRemover.inputImage = selectedImage!
                //         bgRemover.segmentImage()

                //     } else if selectedImage != nil {
                //         bgRemover.outputImage = nil
                //     }
                    
                // } label: {
                //     Image(systemName: "person.circle.fill")
                //         .font(Font.system(size: 50))
                //         .foregroundColor(selectedImage == nil ? .gray : .blue)
                // }
                
                // invert image
                
                Button {
                    
                    if selectedImage != nil {
                        if let flippedImage = imageHelper.flipImageVerticallyAndHorizontally(image: selectedImage!) {
                            selectedImage = flippedImage
                        }
                    }
                                        
                } label: {
                    Image(systemName: "arrow.up.and.down.circle")
                        .font(Font.system(size: 50))
                        .foregroundColor(selectedImage == nil ? .gray : .blue)
                    
                }
                
                
                // add to database button
                Button {
                    
                    if selectedImage != nil {
                        addDatabaseItemMenu = true
                    }
                    
                } label: {
                    ZStack {
                        Image(systemName: "folder.badge.plus")
                            .font(Font.system(size: 20))
                            .foregroundColor(selectedImage == nil ? .gray : .blue)
                        Image(systemName: "circle")
                            .font(Font.system(size: 50, weight: .light))
                            .foregroundColor(selectedImage == nil ? .gray : .blue)
                    }
                }
                .sheet(isPresented: $addDatabaseItemMenu) {
                    ZStack {
                        Color.white.opacity(0).edgesIgnoringSafeArea(.all)
                            .overlay(
                        TabView(selection: $tabBinding) {
                            AddSourceView(image: selectedImage)
                                .environmentObject(navigationStateManager)
                                .tabItem {
                                    Text("Add Source")
                                    Image(systemName: "books.vertical")
                                }
                                .tag(0)
                            AddClippingView(image: selectedImage)
                                .environmentObject(navigationStateManager)
                                .tabItem {
                                    Text("Add Clipping")
                                    Image(systemName: "scissors")
                                }
                                .tag(1)
                        }.background(BackgroundBlurView2())
                       )
                    }.background(BackgroundBlurView())
                    //.background(.ultraThinMaterial)
                }.background(Color.clear)
                
            } // button HStack
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .confirmationDialog("Select image source", isPresented: $isSourceMenuShowing, actions: {
            
            // set the options for the selection sheet
            Button
            {
                self.source = .photoLibrary
                isPickerShowing = true
            } label: {
                Text("Photo Library")
            }
            
            Button {
                self.source = .camera
                isPickerShowing = true
            } label: {
                Text("Camera")
            }
        })
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing, source: self.source)
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

//struct ImageCaptureView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageCaptureView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
