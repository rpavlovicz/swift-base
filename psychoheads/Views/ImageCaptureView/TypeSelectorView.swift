//
//  TypeSelectorView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  TypeSelectorView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 4/30/23.
//

import SwiftUI

struct TypeSelectorView: View {
    
    @Binding var isHead: Bool
    @Binding var isBody: Bool
    @Binding var isAnimal: Bool
    
    var body: some View {
    
            VStack {
                
                ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.systemGroupedBackground))
                            .frame(height: 60)
                            
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5))
                            //.backgroundStyle(Color(.systemGroupedBackground))
                            .frame(height: 40)
                            .padding(.horizontal)
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(Color(.systemGray2))
                                .frame(width: 1, height: 25)
                            Spacer()
                            Rectangle()
                                .fill(Color(.systemGray2))
                                .frame(width: 1, height: 25)
                            Spacer()
                        }.padding(.horizontal, 20)
                        
                        HStack {
                            Spacer()

                            Button("Head") {
                                isHead.toggle()
                            }
                            .buttonStyle(ButtonStyle2(inputColor: isHead ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                            Spacer()

                            Button("Body") {
                                isBody.toggle()
                            }
                            .buttonStyle(ButtonStyle2(inputColor: isBody ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                            Spacer()

                            Button("Animal") {
                                isAnimal.toggle()
                            }
                            .buttonStyle(ButtonStyle2(inputColor: isAnimal ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                            Spacer()
                        } // HStack
                        .padding(.horizontal, 15)
                    } // ZStack
//
//                    HStack {
//                        Group {
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.systemBackground))
//                                .frame(height: 15)
//                                .border(.green)
//                                .padding(.horizontal)
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.secondarySystemBackground))
//                                //.border(.green)
//                                .frame(height: 40)
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.tertiarySystemBackground))
//                                .frame(height: 40)
//                                //.border(.green)
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.secondarySystemGroupedBackground))
//                                .frame(height: 40)
//                                //.border(.green)
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.tertiarySystemGroupedBackground))
//                                .frame(height: 40)
//                                //.border(.green)
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.label))
//                                .frame(height: 40)
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color(.secondaryLabel))
//                                .frame(height: 40)
//
//                        }
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.tertiaryLabel))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray2))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray3))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray4))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray5))
//                            .frame(height: 40)
//
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(.systemGray6))
//                            .frame(height: 40)
//
//                    } // HStack
//                    .padding(.horizontal)
                    
                
                
            } // VStack
           
            
                
        }

}

//struct TypeSelectorView_Previews: PreviewProvider {
//    @State static private var isHead: Bool = false
//    @State static private var isBody: Bool = false
//    @State static private var isAnimal: Bool = false
//    
//    static var previews: some View {
//        TypeSelectorView(isHead: $isHead, isBody: $isBody, isAnimal: $isAnimal)
//    }
//}
