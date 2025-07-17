//
//  RangeSlider2.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/25.
//

import SwiftUI

struct RangeSlider2: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let range: ClosedRange<Double>
    let step: Double
    let accentColor: Color
    
    @State var selectedMinPosition: CGFloat = 0
    @State var selectedMaxPosition: CGFloat = 15
    @State var totalSliderWidth: CGFloat = 0
    
    @State var isDraggingLeft = false
    @State var isDraggingRight = false
    
    let offsetValue: CGFloat = 40
    
    var lowerValue: Int {
        Int(map(value: selectedMinPosition, from: 0...totalSliderWidth, to: range))
    }
    
    var upperValue: Int {
        Int(map(value: selectedMaxPosition, from: 0...totalSliderWidth, to: range))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
            GeometryReader{ geometry in
                
                VStack(spacing: 30) {
                    
                    Text("\(String(format: "%.1f", Double(lowerValue))) - \(String(format: "%.1f", Double(upperValue))) cm").bold()
                        .foregroundStyle(accentColor)

                    ZStack(alignment: .leading) {
                        
                        // grey bar
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray)
                            .opacity(0.3)
                            .frame(height: 6)
                            .padding(.horizontal, 6)
                        
                        
                        // selected range color bar
                        Rectangle()
                            .foregroundStyle(accentColor)
                            .frame(width: selectedMaxPosition - selectedMinPosition, height: 6)
                            .offset(x: selectedMinPosition + 20)
                        
                        HStack(spacing: 0) {
                            DraggableCircle(isLeft: true,
                                            isDragging: $isDraggingLeft,
                                            position: $selectedMinPosition,
                                            otherPosition: $selectedMaxPosition,
                                            limit: totalSliderWidth,
                                            circleColor: accentColor)
                            DraggableCircle(isLeft: false,
                                            isDragging: $isDraggingRight,
                                            position: $selectedMaxPosition,
                                            otherPosition: $selectedMinPosition,
                                            limit: totalSliderWidth,
                                            circleColor: accentColor)
                        } // draggable circle HStack
                        
                        ValueBox(isDragging: isDraggingLeft, value: lowerValue,
                                 position: selectedMinPosition, xOffset: -18)
                        ValueBox(isDragging: isDraggingRight, value: upperValue,
                                 position: selectedMaxPosition, xOffset: 0)
                            
                    } // bar ZStack
                    .offset(y: 8)
                    
                } // VStack
                .frame(maxWidth: geometry.size.width, maxHeight: 130)
                //.padding(.horizontal, 30)
                .onAppear() {
                    totalSliderWidth = geometry.size.width - offsetValue
                    // Initialize positions based on current values
                    selectedMinPosition = map(value: minValue, from: range, to: 0...totalSliderWidth)
                    selectedMaxPosition = map(value: maxValue, from: range, to: 0...totalSliderWidth)
                }
                .onChange(of: selectedMinPosition) { newPosition in
                    minValue = map(value: newPosition, from: 0...totalSliderWidth, to: range)
                }
                .onChange(of: selectedMaxPosition) { newPosition in
                    maxValue = map(value: newPosition, from: 0...totalSliderWidth, to: range)
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
    
    func map(value: Double, from: ClosedRange<Double>, to: ClosedRange<CGFloat>) ->
        CGFloat {
            let inputRange = from.upperBound - from.lowerBound
            guard inputRange != 0 else { return 0 }
            let outputRange = to.upperBound - to.lowerBound
            return CGFloat((value - from.lowerBound) / inputRange) * outputRange + to.lowerBound
        }
    
    func map(value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<Double>) ->
        Double {
            let inputRange = from.upperBound - from.lowerBound
            guard inputRange != 0 else { return 0 }
            let outputRange = to.upperBound - to.lowerBound
            return Double((value - from.lowerBound) / inputRange) * outputRange + to.lowerBound
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
    RangeSlider2(
        minValue: .constant(3.0),
        maxValue: .constant(10.0),
        range: 2.0...15.0,
        step: 0.1,
        accentColor: .green
    )
}
