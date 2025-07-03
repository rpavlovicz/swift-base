//
//  ButtonStyle1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  ButtonStyles.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/25/23.
//

import SwiftUI

struct ButtonStyle1: ButtonStyle {
    
    var inputColor: UIColor = .white
    //@State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            Rectangle()
                .frame(height: 50)
                .cornerRadius(10)
                .foregroundColor(Color(inputColor))
                .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
                .opacity(configuration.isPressed ? 0.4 : 1.0)
                .animation(.easeIn(duration: 0.2), value: configuration.isPressed)
//                .pressEvents {
//                    withAnimation(.easeIn(duration: 0.2)) {
//                        isPressed = true
//                    }
//                } onRelease: {
//                    withAnimation {
//                        isPressed = false
//                    }
//                }
            
            configuration.label
                .font(Font.system(size:14))
                .foregroundColor(.white)
                
            
        }
        //.padding([.leading, .trailing])

    }
    
}

struct ButtonStyle2: ButtonStyle {
    
    var inputColor: Color = .gray
    //@State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            Rectangle()
                .frame(height: 30)
                .cornerRadius(7)
                .foregroundColor(inputColor)
                .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
                .opacity(configuration.isPressed ? 0.4 : 1.0)
                .animation(.easeIn(duration: 0.2), value: configuration.isPressed)
            
            configuration.label
                .font(Font.system(size:14))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                
            
        }
        //.padding([.leading, .trailing])

    }
    
}


struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({_ in
                        onPress()
                    })
                    .onEnded({_ in
                        onRelease()
                    })
            )
    }
     
}

extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}
