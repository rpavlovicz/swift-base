//
//  SearchSelectorView1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  SearchSelectorView1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 9/17/23.
//

import SwiftUI

struct SearchSelectorView1: View {
    
    @Binding var searchHeads: Bool
    @Binding var searchTags: Bool
    @Binding var lookingDirection: LookingDirection?
    
    var body: some View {
        
        VStack {
            
            ZStack(alignment: .center) {

                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(.systemGray5))
                    .frame(height: 35)
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 25)
                    Spacer()
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 25)
                    Spacer()
                }.padding(.horizontal, 2)
                    
                HStack(spacing: 5) {

                    Button("Heads") {
                        searchHeads.toggle()
                    }
                    .buttonStyle(ButtonStyle2(inputColor: searchHeads ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                    Button("Tags") {
                        searchTags.toggle()
                    }
                    .buttonStyle(ButtonStyle2(inputColor: searchTags ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                } // HStack
                .padding(.horizontal,4)
                
            } // ZStack
            
            //Section(header: Text("Looking Direction")) {
                
                HStack {
                    DirectionSelectorView(lookingDirection: $lookingDirection)
//                        .onChange(of: lookingDirection) { newValue in
//                            lookingDirection = newValue?.rawValue ?? ""
//                        }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Looking:").bold()
                        if let direction = lookingDirection {
                            Text("\(direction.rawValue)")
                        } else {
                            Text("None")
                        }
                    }
                    .padding(.leading,30)
                    
                }
                
            //}
            
            //DirectionSelectorView()
            
        } // VStack
        .background(Color.clear)
        
    }
}

//struct SearchSelectorView1_Previews: PreviewProvider {
//    @State static private var searchHeads: Bool = true
//    @State static private var searchTags: Bool = false
//    @State static private var lookingDirection: LookingDirection?
//    
//    static var previews: some View {
//        SearchSelectorView1(searchHeads: $searchHeads, searchTags: $searchTags, lookingDirection: $lookingDirection)
//    }
//}
