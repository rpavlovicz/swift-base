//
//  ImagePlaceholderView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 1/12/25.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 80))
                    .foregroundColor(.gray.opacity(0.6))
                
                VStack(spacing: 8) {
                    Text("No Image Selected")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    
                    Text("Tap the camera button below to take a photo or select from your library")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .frame(width: 340, height: 550)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
            )
            
            Spacer()
        }
    }
}

struct ImagePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePlaceholderView()
            .previewDisplayName("Image Placeholder")
    }
} 