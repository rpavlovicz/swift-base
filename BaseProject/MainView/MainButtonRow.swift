//
//  MainButtonRow.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/24/23.
//

import SwiftUI

struct MainButtonRow: View {

    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var showingMoreOptions = false
    
    // Primary buttons (shown by default)
    var primaryButtons: some View {
        HStack {
            Spacer()
            // Camera (add new)
            NavigationLink(value: SelectionState.imageCapture, label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "camera")
                        .font(.system(size: 26, weight: .regular))
                        .padding(10)
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            })
            
            Spacer()
            
            ZStack(alignment: .topTrailing) {
                Image(systemName: "camera")
                    .font(.system(size: 26, weight: .regular))
                    .padding(10)
                Image(systemName: "magnifyingglass")
            }
            
            Spacer()
            
            // Library
            NavigationLink(value: SelectionState.library, label: {
                Image(systemName: "books.vertical")
                    .font(.system(size: 26, weight: .regular))
                    .padding(10)
            })
            
            Spacer()
            
            // Search
            NavigationLink(value: SelectionState.searchClippings(nil), label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26, weight: .regular))
                    .padding(10)
            })
            
            Spacer()
            
            NavigationLink(value: SelectionState.collageView, label: {
                ZStack {
                    // Bottom layer
                    Image(systemName: "face.smiling")
                        .font(.system(size: 15, weight: .regular))
                        .padding(10)
                        .offset(x: -10, y: 8)
                    
                    // Middle layer
                    Image(systemName: "face.smiling")
                        .font(.system(size: 20, weight: .regular))
                        .padding(10)
                        .offset(x: 9, y: 9)
                    
                    // Top layer
                    Image(systemName: "face.smiling")
                        .font(.system(size: 22, weight: .regular))
                        .padding(10)
                        .offset(x: -1, y: -6)
                }
            })
            
            Spacer()
        }
    }
    
    // Secondary buttons (shown when More is pressed)
    var secondaryButtons: some View {
        HStack {
            Spacer()
            // Camera search

            
            Spacer()
            
            // Reports
            NavigationLink(value: SelectionState.reportView, label: {
                Image(systemName: "rectangle.stack.badge.person.crop")
                    .font(.system(size: 26, weight: .regular))
                    .padding(10)
            })
            
            Spacer()
            
            // Settings
            NavigationLink(value: SelectionState.accountSettings, label: {
                Image(systemName: "gear")
                    .font(.system(size: 26, weight: .regular))
                    .padding(10)
            })
            
            Spacer()
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            HStack(spacing: 0) {
                // Dynamic content area
                if showingMoreOptions {
                    secondaryButtons
                } else {
                    primaryButtons
                }
                
                // Fixed More button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingMoreOptions.toggle()
                    }
                }) {
                    Image(systemName: showingMoreOptions ? "chevron.right" : "ellipsis")
                        .font(.system(size: 26, weight: .regular))
                        .padding(10)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
}

//struct MainButtonRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MainButtonRow()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
