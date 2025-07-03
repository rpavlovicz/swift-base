//
//  TypeSelectorView1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  TypeSelectorView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 4/30/23.
//

import SwiftUI

struct TypeSelectorView1: View {
    
    @Binding var isHead: Bool
    @Binding var isBody: Bool
    @Binding var isAnimal: Bool
    
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

                        Button("Head") {
                            isHead.toggle()
                        }
                        .buttonStyle(ButtonStyle2(inputColor: isHead ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                        Button("Body") {
                            isBody.toggle()
                        }
                        .buttonStyle(ButtonStyle2(inputColor: isBody ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                        Button("Animal") {
                            isAnimal.toggle()
                        }
                        .buttonStyle(ButtonStyle2(inputColor: isAnimal ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                    } // HStack
                    .padding(.horizontal,4)
                } // ZStack
            } // VStack

        } // body

}

//struct TypeSelectorView1_Previews: PreviewProvider {
//    @State static private var isHead: Bool = false
//    @State static private var isBody: Bool = false
//    @State static private var isAnimal: Bool = false
//
//    static var previews: some View {
//        TypeSelectorView1(isHead: $isHead, isBody: $isBody, isAnimal: $isAnimal)
//    }
//}
