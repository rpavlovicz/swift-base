//
//  DisplayMode.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/25/25.
//


//
//  SourceRowView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/30/23.
//

import SwiftUI
import Combine
import FirebaseStorage

enum DisplayMode2 {
    case thumbnail
    case minimal
}

// TODO: i'm not sure this is used. delete?
enum DisplaySize {
    case library
    case edit
}

struct SourceRowView2: View {
    
    @ObservedObject var source: Source
    let displayMode: DisplayMode2
    let placeholderImage: UIImage? = UIImage(named: "source_thumb")
    @StateObject private var imageLoader = ImageLoader()
    
    // Device-specific scaling factor
    private var imageScale: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0
    }
    
    private var imageSize: CGFloat {
        return 100 * imageScale
    }
    
    // Device-specific text scaling
    private var textScale: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 1.2 : 1.0
    }
    
    private func scaledFont(_ baseFont: Font) -> Font {
        switch baseFont {
        case .headline:
            return textScale > 1.0 ? .system(size: 28, weight: .medium) : .headline
        case .subheadline:
            return textScale > 1.0 ? .system(size: 18, weight: .regular) : .subheadline
        case .footnote:
            return textScale > 1.0 ? .system(size: 15, weight: .regular) : .footnote
        default:
            return baseFont
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            if displayMode == .thumbnail {
                
                HStack(spacing: 20) {
                        
                    if source.imageThumb != nil {
                        Image(uiImage: source.imageThumb!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                    } else {
                        if let image = placeholderImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize, height: imageSize)
                        }
                        
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text(source.title)
                            .font(scaledFont(.headline))
                        if let issue = source.issue, !issue.isEmpty {
                            Text(source.issue!)
                                .font(scaledFont(.subheadline))
                        }
                        Text(source.dateString)
                            .font(scaledFont(.subheadline))
//                        Text("\nNumber of copies: \(source.ncopies)")
//                            .font(.footnote)
                        Text("\nNumber of clippings: \(source.clippings.count)")
                            .font(scaledFont(.footnote))

                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text(source.title)
                        .font(scaledFont(.headline))
                    HStack {
                        Text(source.dateString)
                            .font(scaledFont(.subheadline))
                        Spacer()
                        Text("# of clippings: \(source.clippings.count)")
                            .font(scaledFont(.subheadline))
                            .foregroundStyle(Color(.systemGray))
                    }
                    .padding(.trailing, 5)
                    
                }
            }
            
        }
        .alignmentGuide(.listRowSeparatorLeading) { ViewDimensions in
            return 0
        }
        .onAppear {
            if displayMode == .thumbnail {
                if source.imageThumb == nil {
                    print("source.imageThumb was nil... loading image")
                    imageLoader.load(imagePath: source.imageUrlThumb, useCache: true) { success, downloadedImage in
                        if success, let validImage = downloadedImage {
                            source.imageThumb = downloadedImage
                        } else {
                            source.imageThumb = UIImage(named: "broken_image_link")
                        }
                    }
                }
            }
        }
                
    }
    
}

struct SourceRowView2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SourceRowView2(
                source: Source(title: "Sample Magazine", year: "2023", month: "January"),
                displayMode: .thumbnail
            )
            SourceRowView2(
                source: Source(title: "Another Source", year: "2022"),
                displayMode: .minimal
            )
        }
        .padding()
    }
}
