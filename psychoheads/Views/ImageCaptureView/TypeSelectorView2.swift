//
//  TypeSelectorView2.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  TypeSelector.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 5/21/23.
//

import SwiftUI

struct TypeSelectorView2: View {
    
    @Binding var isMan: Bool
    @Binding var isWoman: Bool
    @Binding var isTrans: Bool
    @Binding var isWhite: Bool
    @Binding var isBlack: Bool
    @Binding var isLatino: Bool
    @Binding var isAsian: Bool
    @Binding var isIndian: Bool
    @Binding var isNative: Bool
    @Binding var isBW: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(.systemGray5))
                    .frame(height: 35)
                HStack {
                    Group {
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                    }
                    
                    Group {
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                    }
                    Group {
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 25)
                        Spacer()
                    }
                }.padding(.horizontal, 2)
                
                HStack(spacing: 10) {
                    Button {
                        isMan.toggle()
                    } label: {
                        Text(Constants.man)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isMan ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isWoman.toggle()
                    } label: {
                        Text(Constants.woman)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isWoman ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isTrans.toggle()
                    } label: {
                        Text(Constants.trans)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isTrans ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isWhite.toggle()
                    } label: {
                        Text(Constants.white)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isWhite ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isBlack.toggle()
                    } label: {
                        Text(Constants.black)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isBlack ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))

                    Button {
                        isLatino.toggle()
                    } label: {
                        Text(Constants.latino)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isLatino ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isAsian.toggle()
                    } label: {
                        Text(Constants.asian)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isAsian ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                   
                    Button {
                        isIndian.toggle()
                    } label: {
                        Text(Constants.indian)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isIndian ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                   
                    Button {
                        isNative.toggle()
                    } label: {
                        Text(Constants.native)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isNative ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                    Button {
                        isBW.toggle()
                    } label: {
                        Text(Constants.blackAndWhite)
                    }
                    .buttonStyle(ButtonStyle2(inputColor: isBW ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                    
                }.padding(.horizontal,5)
            }
        }
        
    }
}

//struct TypeSelectorView2_Previews: PreviewProvider {
//    @State static private var isMan: Bool = false
//    @State static private var isWoman: Bool = false
//    @State static private var isTrans: Bool = false
//    @State static private var isWhite: Bool = false
//    @State static private var isBlack: Bool = false
//    @State static private var isLatino: Bool = false
//    @State static private var isAsian: Bool = false
//    @State static private var isIndian: Bool = false
//    @State static private var isNative: Bool = false
//    @State static private var isBW: Bool = false
//    
//    static var previews: some View {
//        TypeSelectorView2(isMan: $isMan, isWoman: $isWoman, isTrans: $isTrans, isWhite: $isWhite, isBlack: $isBlack, isLatino: $isLatino, isAsian: $isAsian, isIndian: $isIndian, isNative: $isNative, isBW: $isBW)
//    }
//}
