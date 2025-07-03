//
//  EditTagsSheetView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  EditTagsSheetView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 12/25/23.
//

import SwiftUI

struct EditTagsSheetView: View {
    
    @Binding var tags: [String]
    @Binding var isPresented: Bool
    @State private var showTextField = false // Add a local state to track the text field status of WrappingHStackWithAdd
    
    var body: some View {
        VStack {
            Text("Edit Clipping Tags")
                .font(.title3)
                .padding(.top,10)
                .padding(.bottom,30)
            
            VStack(alignment:.leading) {
                
                WrappingHStackWithAdd(items: $tags, showTextField: $showTextField)
                
                Button("Accept") {
                    isPresented = false
                }
                .buttonStyle(ButtonStyle1(inputColor: .blue))
                .opacity(tags.isEmpty || showTextField ? 0 : 1)
                .padding(.top,20)
                
            }
            .padding(.horizontal,20)
            Spacer()
        }
        
    }
}

//struct EditTagsSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        @State var tags = ["one","two","three","four","five","six","seven"]
//        @State var previewIsPresented = true
//        
//        return EditTagsSheetView(tags: $tags, isPresented: $previewIsPresented)
//    }
//}


