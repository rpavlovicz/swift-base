//
//  RangeSlider2.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/25.
//

import SwiftUI

struct RangeSlider2: View {
    @State var width: CGFloat = 0
    @State var widthTow: CGFloat = 15
    @State var height: CGFloat = 15
    @State var totalScreen: CGFloat = 0
    
    @State var isDraggingLeft = false
    @State var isDraggingRight = false
    
    let maxValue: CGFloat = 1000
    let offsetValue: CGFloat = 40
    let barfillColor: Color
    
    var lowerValue: Int {
        Int(map(value: width, from: 0...totalScreen, to: 0...maxValue))
    }
    
    var upperValue: Int {
        Int(map(value: widthTow, from: 0...totalScreen, to: 0...maxValue))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
            GeometryReader{ geometry in
                
                VStack(spacing: 30) {
                    
                    Text("\(lowerValue) cm - \(upperValue) cm").bold()
                        .foregroundStyle(barfillColor)

                    ZStack(alignment: .leading) {
                        
                        // grey bar
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray)
                            .opacity(0.3)
                            .frame(height: 6)
                            .padding(.horizontal, 6)
                        
                        
                        // selected range color bar
                        Rectangle()
                            .foregroundStyle(barfillColor)
                            .frame(width: widthTow - width, height: 6)
                            .offset(x: width + 20)
                        
                        HStack(spacing: 0) {
                            DraggableCircle(isLeft: true,
                                            isDragging: $isDraggingLeft,
                                            position: $width,
                                            otherPosition: $widthTow,
                                            limit: totalScreen,
                                            circleColor: barfillColor)
                            DraggableCircle(isLeft: false,
                                            isDragging: $isDraggingRight,
                                            position: $widthTow,
                                            otherPosition: $width,
                                            limit: totalScreen,
                                            circleColor: barfillColor)
                        } // draggable circle HStack
                        
                        ValueBox(isDragging: isDraggingLeft, value: lowerValue,
                                 position: width, xOffset: -18)
                        ValueBox(isDragging: isDraggingRight, value: upperValue,
                                 position: widthTow, xOffset: 0)
                            
                    } // bar ZStack
                    .offset(y: 8)
                    
                } // VStack
                .frame(maxWidth: geometry.size.width, maxHeight: 130)
                //.padding(.horizontal, 30)
                .onAppear() {
                    totalScreen = geometry.size.width - offsetValue
                }

            } // GeometryReader
            .frame(height: 130)
            .padding(.horizontal, 30)
            .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 10)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 0)
        }
        .ignoresSafeArea()
        
        
    } // View
    
    func map(value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) ->
        CGFloat {
            let inputRange = from.upperBound - from.lowerBound
            guard inputRange != 0 else { return 0 }
            let outputRange = to.upperBound - to.lowerBound
            return (value - from.lowerBound) / inputRange * outputRange + to.lowerBound
        }
    
}

struct DraggableCircle: View {
    
    var isLeft: Bool
    @Binding var isDragging: Bool
    @Binding var position: CGFloat
    @Binding var otherPosition: CGFloat
    var limit: CGFloat
    var circleColor: Color
    
    var body: some View {
        ZStack {
            Circle().frame(width: 25, height: 25).foregroundStyle(circleColor)
            Circle().frame(width: 15, height: 25).foregroundStyle(.white)
        } // ZStack
        .offset(x: position + (isLeft ? 0 : -5))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation {
                        isDragging = true
                    }
                    if isLeft {
                        position = min( max(value.location.x, 0), otherPosition )
                    } else {
                        position = min( max(value.location.x, otherPosition), limit )
                    }
                }) // onChanged
                .onEnded({ value in
                    withAnimation {
                        isDragging = false
                    }
                })
            
        ) // gesture
            
    } // View
} // DraggableCircle struct

struct ValueBox: View {
    
    var isDragging: Bool
    var value: Int
    var position: CGFloat
    var xOffset: CGFloat
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 60, height: 40)
                .foregroundStyle(isDragging ? .black : .clear)
            Text("$\(value)")
                .foregroundStyle(isDragging ? .white : .clear)
        }
        .scaleEffect(isDragging ? 1: 0)
        .offset(x: position + xOffset, y: isDragging ? -40 : 0)
        
    } // View
    
} // ValueBox struct

#Preview {
    RangeSlider2(barfillColor: Color(.green))
}
