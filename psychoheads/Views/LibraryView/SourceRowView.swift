//
//  SourceRowView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/25/25.
//

import SwiftUI

enum DisplayMode {
    case minimal
    case thumbnail
}

struct SourceRowView: View {
    @ObservedObject var source: Source
    let displayMode: DisplayMode
    let placeholderImage: UIImage? = UIImage(named: "source_thumb")
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        HStack {
            if displayMode == .thumbnail {
                if let image = source.imageThumb {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                } else if let placeholderImage {
                    Image(uiImage: placeholderImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(source.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(source.dateString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !source.type.isEmpty {
                    Text(source.type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(source.clippings.count) clippings")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .onAppear {
            guard displayMode == .thumbnail, source.imageThumb == nil else { return }
            imageLoader.load(imagePath: source.imageUrlThumb, useCache: true) { success, downloadedImage in
                if success, let downloadedImage {
                    source.imageThumb = downloadedImage
                } else {
                    source.imageThumb = UIImage(named: "broken_image_link")
                }
            }
        }
    }
}

struct SourceRowView_Previews: PreviewProvider {
    static var previews: some View {
        SourceRowView(
            source: Source(title: "Sample Source", year: "2023"),
            displayMode: .minimal
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
} 
