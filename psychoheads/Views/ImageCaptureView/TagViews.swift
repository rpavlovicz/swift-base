//
//  Tag.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  TagViews.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/3/23.
//

import SwiftUI

struct Tag: Identifiable, Codable {
    let id = UUID()
    var text: String
    var count: Int
}

// capsule tag view with toggle delete button
struct TagView: View {
    var tag: String?
    var onDelete: (() -> Void)?
    @State private var isPressed: Bool = false
    @Binding var toggledTag: String?
    
    var body: some View {
        
        Button {
            isPressed.toggle()
            if isPressed {
                toggledTag = tag
            } else {
                toggledTag = nil
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Text(tag!)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundColor(.black)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                    .overlay(
                        Group {
                            if isPressed {
                                Button(action: onDelete!, label: {
                                    Image(systemName: "x.circle.fill")
                                })
                                .offset(x: 10, y: -10)
                                .contentShape(Rectangle())
                            }
                        }, alignment: .topTrailing
                    )
            }.padding(.top, 3)
        }
        .onAppear{
            isPressed = (tag == toggledTag)
        }
        .onChange(of: toggledTag) { _ in
            isPressed = (tag  == toggledTag)
        }
        
    } // TagView View body
    
}

// capsule tag view without delete toggle button
struct TagView2: View {
    var tag: String?
    var onTagTapped: (() -> Void)?
    
    var body: some View {
        
        Button {
            onTagTapped?()
        } label: {
            ZStack {
                Text(tag!)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }.padding(.top, 3)
        }
    } // TagView View body
    
}

//struct TagView_Previews: PreviewProvider {
//    static var tag: String = "test"
//    static var toggledTag: String? = nil
//    
//    static var previews: some View {
//        TagView(tag: tag, onDelete: {}, toggledTag: .constant(toggledTag))
//        //TagView2(tag: tag)
//    }
//}
