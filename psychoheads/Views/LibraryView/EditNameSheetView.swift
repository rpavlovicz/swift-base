//
//  EditNameSheetView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  EditNameSheetView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 12/24/23.
//

import SwiftUI

struct EditNameSheetView: View {
    
    var clippingName: String
    @Binding var editName: String
    @Binding var isPresented: Bool
    
    @State private var localEditName: String
    
    init(clippingName: String, editName: Binding<String>, isPresented: Binding<Bool>) {
        self.clippingName = clippingName
        self._editName = editName
        self._isPresented = isPresented
        _localEditName = State(initialValue: editName.wrappedValue)
    }
    
    var body: some View {
        VStack {
            Text("Edit Clipping Name")
                .font(.title3)
                .padding(.vertical,30)
            
            VStack(alignment:.leading) {
                
                
                HStack {
                    Text("Original clipping name: ").bold()
                    Text("\(clippingName)")
                }
                
                HStack {
                    Text("New name: ").bold()
                    TextField("New name: ", text: $localEditName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                Button("Accept") {
                    editName = localEditName
                    isPresented = false
                }
                .buttonStyle(ButtonStyle1(inputColor: .blue))
                .padding(.top,20)

                
            }
            .padding(.horizontal,20)
            Spacer()
        }
        
    }
}

//struct EditNameSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let fixedClippingName = "Sample Name"
//        @State var previewClippingName = ""
//        @State var previewIsPresented = true
//        
//        return EditNameSheetView(clippingName: fixedClippingName, editName: $previewClippingName, isPresented: $previewIsPresented)
//    }
//}
