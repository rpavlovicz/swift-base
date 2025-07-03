//
//  DimensionRatioView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  DimensionRatioView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/22/23.
//

import SwiftUI

struct DimensionRatioView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let image: UIImage
    @State private var horizontalXValue: CGFloat = 0
    @State private var horizontalSpacing: CGFloat = 0
    
    @State private var verticalYValue: CGFloat = 0
    @State private var verticalSpacing: CGFloat = 0
    
    @State private var guidelinesHeight: CGFloat = 0
    @State private var guidelinesWidth: CGFloat = 0

    @State private var totalHeightRatio: CGFloat = 0
    @State private var totalWidthRatio: CGFloat = 0
    @Binding var headHeightRatio: CGFloat?
    @Binding var headWidthRatio: CGFloat?
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .background(Color.clear)
                        .overlay(GuidelinesView(horizontalXValue: $horizontalXValue, horizontalSpacing: $horizontalSpacing, verticalYValue: $verticalYValue, verticalSpacing: $verticalSpacing, guidelinesHeight: $guidelinesHeight, guidelinesWidth: $guidelinesWidth, headHeightRatio: $headHeightRatio, headWidthRatio: $headWidthRatio), alignment: .topLeading)
                        .onAppear {
                            self.horizontalXValue = guidelinesWidth * 0.1
                            self.horizontalSpacing = guidelinesWidth * 0.9 - guidelinesWidth * 0.1
                            
                            self.verticalYValue = guidelinesHeight * 0.1
                            self.verticalSpacing = guidelinesHeight * 0.9 - guidelinesHeight * 0.1
                            
                            
                            let aspectRatio = image.size.width / image.size.height
                            if image.size.height > image.size.width {
                                totalHeightRatio = 1.0
                                totalWidthRatio = aspectRatio
                            } else {
                                totalHeightRatio = 1 / aspectRatio
                                totalWidthRatio = 1.0
                            }
                            
                        }
                    Spacer()
                    
                    // MARK: - sliders
                    Group {
                        Text("Head width:")
                        Slider(value: $horizontalSpacing, in: horizontalXValue < guidelinesWidth - 0.1 ? 0...(guidelinesWidth - horizontalXValue) : 0...1, step: 1)
                            .padding([.leading, .trailing], 20)

                        Text("Head height:")
                            .padding(.top, 20)
                        Slider(value: $verticalSpacing, in: verticalYValue < guidelinesHeight - 0.1 ? 0...(guidelinesHeight - verticalYValue) : 0...1, step: 1)
                            .padding([.leading, .trailing], 20)
                    }
                    
                    // MARK: - ratio printouts
                    Group {
                        HStack {
                            Text("Total Height: \(String(format: "%.2f", totalHeightRatio))")
                            Text("Width: \(String(format: "%.2f",totalWidthRatio))")
                        }
                        .padding(.top, 20)
                        HStack {
                            Text("Head Height: \(String(format: "%.2f", headHeightRatio ?? ""))")
                            Text("Width: \(String(format: "%.2f",headWidthRatio ?? ""))")
                        }
                        .padding(.bottom,0)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button("Accept Ratios") {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(ButtonStyle1(inputColor: .blue))
                        .padding(.trailing)
                        
                        Button {
                            headHeightRatio = nil
                            headWidthRatio = nil
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "lock.slash")
                        }
                        .buttonStyle(ButtonStyle1(inputColor: .gray))
                        .frame(width: 50)
                    }
                    
                }
            } // VStack
            .padding(20)
            .navigationBarBackButtonHidden(true)
        } // GeometryReader
        .padding()
    }
}

// MARK: - GuidelinesView
struct GuidelinesView: View {
    
    @Binding var horizontalXValue: CGFloat
    @Binding var horizontalSpacing: CGFloat

    @Binding var verticalYValue: CGFloat
    @Binding var verticalSpacing: CGFloat
    
    @Binding var guidelinesHeight: CGFloat
    @Binding var guidelinesWidth: CGFloat
    
    @Binding var headHeightRatio: CGFloat?
    @Binding var headWidthRatio: CGFloat?
    
    let lineExtension: CGFloat = 0
    let dashLength: CGFloat = 8
    let dashSpacing: CGFloat = 3

    var body: some View {
        GeometryReader { geometry in
            
            ZStack {

                //MARK: - fixed lines along edges of image
                Path { path in

                    let numberOfDashesX = Int((geometry.size.width + 2*lineExtension) / (dashLength + dashSpacing))
                    let numberOfDashesY = Int((geometry.size.height + 2*lineExtension) / (dashLength + dashSpacing))

                    for index in 0..<numberOfDashesX {
                        let x = (dashLength + dashSpacing) * CGFloat(index) - lineExtension

                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x + dashLength, y: 0))

                        path.move(to: CGPoint(x: x, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: x + dashLength, y: geometry.size.height))
                    }
                    for index in 0..<numberOfDashesY {
                        let y = (dashLength + dashSpacing) * CGFloat(index) - lineExtension
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: 0, y: y + dashLength))

                        path.move(to: CGPoint(x: geometry.size.width, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y + dashLength))
                    }

                    path.closeSubpath()
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))

                //MARK: - vertical adjustable lines
                // dummy vertical rectangle that responds to DragGesture
                Rectangle()
                    .fill(Color.gray.opacity(0.01))
                    .frame(width: 20, height: geometry.size.height)
                    .position(x: horizontalXValue, y: geometry.size.height / 2)
                    .gesture(DragGesture().onChanged({ value in
                        horizontalXValue = min(max(value.location.x, 0), geometry.size.width - 0.1)
                        if horizontalXValue + horizontalSpacing > geometry.size.width {
                            horizontalSpacing = geometry.size.width - horizontalXValue
                        }
                    }))
                
                // vertical line that shifts with DragGesture of clear rectangle
                Path { path in

                    let x = horizontalXValue

                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [5]))
                
                // verical line that shifts with slider and with respect to DragLine
                Path { path in
                    let x = horizontalXValue + horizontalSpacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [5]))

                //MARK: - horizontal adjustable lines
                // dummy horizontal rectangle that responds to DragGesture
                Rectangle()
                    .fill(Color.gray.opacity(0.01))
                    .frame(width: geometry.size.width, height: 20)
                    .position(x: geometry.size.width / 2, y: verticalYValue)
                    //.position(x: horizontalXValue, y: geometry.size.height / 2)
                    .gesture(DragGesture().onChanged({ value in
                        verticalYValue = min(max(value.location.y, 0), geometry.size.height - 0.1)
                        if verticalYValue + verticalSpacing > geometry.size.height {
                            verticalSpacing = geometry.size.height - verticalYValue
                        }
                    }))
                
                // horizontal line that shifts with DragGesture of clear rectangle
                Path { path in

                    let y = verticalYValue

                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [5]))
                
                // verical line that shifts with slider and with respect to DragLine
                Path { path in
                    let y = verticalYValue + verticalSpacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, dash: [5]))
                
            } // ZStack
            .onAppear {
                self.guidelinesHeight = geometry.size.height
                self.guidelinesWidth = geometry.size.width
                self.headHeightRatio = verticalSpacing / geometry.size.height
                self.headWidthRatio = horizontalSpacing / geometry.size.width
            }
            .onChange(of: verticalSpacing) { newValue in
                headHeightRatio = newValue / guidelinesHeight
            }
            .onChange(of: horizontalSpacing) { newValue in
                headWidthRatio = newValue / guidelinesWidth
            }
        } // GeometryReader
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        
    }
}

//
//struct DimensionRatioView_Previews: PreviewProvider {
//    
//    @State static var dummyHeadHeightRatio: CGFloat?
//    @State static var dummyHeadWidthRatio: CGFloat?
//    
//    static var previews: some View {
//        
//        DimensionRatioView(image: UIImage(named: "headClipping_mid") ?? UIImage(), headHeightRatio: $dummyHeadHeightRatio,
//                           headWidthRatio: $dummyHeadWidthRatio)
//        
//    }
//    
//}
