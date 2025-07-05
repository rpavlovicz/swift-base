//
//  ImageCaptureButtonRow.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 1/12/25.
//

import SwiftUI

struct ImageCaptureButtonRow: View {
    @Binding var selectedImage: UIImage?
    @Binding var isSourceMenuShowing: Bool
    @Binding var addDatabaseItemMenu: Bool
    @Binding var tabBinding: Int
    @Binding var backgroundColorIndex: Int
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    private let imageHelper = ImageHelperFunctions()
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()

            
            HStack {
                Spacer()
                
                // Camera/Select Image Button
                Button {
                    isSourceMenuShowing = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "camera")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Select")
                            .font(.caption2)
                    }
                }
                
                Spacer()
                
                // Flip Image Button
                Button {
                    if selectedImage != nil {
                        if let flippedImage = imageHelper.flipImageVerticallyAndHorizontally(image: selectedImage!) {
                            selectedImage = flippedImage
                        }
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.up.and.down.circle")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Flip")
                            .font(.caption2)
                    }
                }
                .foregroundColor(selectedImage == nil ? .gray : .blue)
                
                Spacer()
                
                // Background Color Button
                Button {
                    backgroundColorIndex = (backgroundColorIndex + 1) % 3
                } label: {
                    VStack(spacing: 4) {
                        //Image(systemName: "paintbrush.fill")
                        //Image(systemName: "drop.halffull")
                        Image(systemName: "paint.bucket.classic")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("BG")
                            .font(.caption2)
                    }
                }
                .foregroundColor(selectedImage == nil ? .gray : .blue)
                
                Spacer()
                
                // Add to Database Button
                Button {
                    if selectedImage != nil {
                        addDatabaseItemMenu = true
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Add")
                            .font(.caption2)
                    }
                }
                .foregroundColor(selectedImage == nil ? .gray : .blue)
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
                    .presentationSizing(.page)
                }
//                .if(isPad) { view in
//                    view.presentationSizing(.page)
//                }
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
}

struct ImageCaptureButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        ImageCaptureButtonRow(
            selectedImage: .constant(nil),
            isSourceMenuShowing: .constant(false),
            addDatabaseItemMenu: .constant(false),
            tabBinding: .constant(0),
            backgroundColorIndex: .constant(0)
        )
        .environmentObject(NavigationStateManager())
        .previewDisplayName("Empty State")
        
        ImageCaptureButtonRow(
            selectedImage: .constant(UIImage(named: "source_thumb")),
            isSourceMenuShowing: .constant(false),
            addDatabaseItemMenu: .constant(false),
            tabBinding: .constant(0),
            backgroundColorIndex: .constant(0)
        )
        .environmentObject(NavigationStateManager())
        .previewDisplayName("With Image")
    }
} 
