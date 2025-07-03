//
//  LookingDirection.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  DirectionSelectorView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/19/23.
//

import SwiftUI

enum LookingDirection: String {
    case upperLeft = "upperLeft"
    case up = "up"
    case upperRight = "upperRight"
    case left = "left"
    case fullFace = "fullFace"
    case right = "right"
    case lowerLeft = "lowerLeft"
    case down = "down"
    case lowerRight = "lowerRight"
}

struct DirectionSelectorView: View {
    
    @Binding var lookingDirection: LookingDirection?

    var body: some View {
        VStack(spacing: 1) {
            directionRow(for: [.upperLeft, .up, .upperRight])
            directionRow(for: [.left, .fullFace, .right])
            directionRow(for: [.lowerLeft, .down, .lowerRight])
        }
    }

    private func directionRow(for directions: [LookingDirection]) -> some View {
        HStack(spacing: 1) {
            ForEach(directions, id: \.self) { direction in
                Button {
                    if lookingDirection == direction {
                        lookingDirection = nil
                    } else {
                        lookingDirection = direction
                    }
                } label: {
                    Text(emoji(for: direction))
                }
                .buttonStyle(ButtonStyle2(inputColor: lookingDirection == direction ? Color(.secondarySystemGroupedBackground) : Color(.systemGray5)))
                .frame(width: 30)
            }
        }
    }

    private func emoji(for direction: LookingDirection) -> String {
        switch direction {
        case .upperLeft: return Constants.lookingUpperLeft
        case .up: return Constants.lookingUp
        case .upperRight: return Constants.lookingUpperRight
        case .left: return Constants.lookingLeft
        case .fullFace: return Constants.lookingFullFace
        case .right: return Constants.lookingRight
        case .lowerLeft: return Constants.lookingLowerLeft
        case .down: return Constants.lookingDown
        case .lowerRight: return Constants.lookingLowerRight
        }
    }
}


//struct DirectionSelectorView_Previews: PreviewProvider {
//
//    @State static var direction: LookingDirection? = nil
//    
//    static var previews: some View {
//        DirectionSelectorView(lookingDirection: $direction)
//    }
//}
