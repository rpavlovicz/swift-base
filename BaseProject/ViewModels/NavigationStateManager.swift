//
//  NavigationStateManager.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 4/23/23.
//

import SwiftUI
import Foundation
import Combine

enum SelectionState: Hashable, Codable {
    case edit(Source)
    case library
    case imageCapture
    case sourceView(Source)
    case clippingView(Clipping)
    case clippingsSwipeView([Clipping], currentIndex: Int)
    case searchClippings([Clipping]?)
    //case searchClippings
    case editClippingView(Clipping)
    case editClippingSourceView(Clipping)
    case collageView
    case reportView
    case reportSourceDetailView
    case reportClippingDetailView
    case progressReportView
    case psychoView
    case accountSettings
    case newUser
    case existingUser
}

class NavigationStateManager: ObservableObject {
    
    @Published var selectionPath = [SelectionState]()
    
    func goToLibrary() {
        selectionPath = [SelectionState.library]
    }
    
    func goToPsycho() {
        selectionPath = [SelectionState.psychoView]
    }
    
    var data: Data? {
        get {
            try? JSONEncoder().encode(selectionPath)
        }
        set {
            guard let data = newValue,
                  let path = try? JSONDecoder().decode([SelectionState].self, from: data) else {
                return
            }
            self.selectionPath = path
        }
    }
    
    func popBack() {
        print("length of selectionPath before popBack = \(selectionPath.count)")
        selectionPath.removeLast()
        print("length of selectionPath after popBack = \(selectionPath.count)")
    }
    
}
