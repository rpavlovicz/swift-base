//
//  MainView.swift
//  BaseProject
//
//  Created by Ryan Pavlovicz on 3/10/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var sourceModel = SourceModel()
    @StateObject var navigationStateManager = NavigationStateManager()
    
    var body: some View {
        
        NavigationStack(path: $navigationStateManager.selectionPath) {
    
            VStack {
        
                Spacer()
                
                Text("Welcome to BaseProject")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                // Button Row
                MainButtonRow()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .environmentObject(sourceModel)
                    .environmentObject(navigationStateManager)
 
            }
//            .onAppear() {
//                // ensure reload only happens after logout
//                if sourceModel.sources.isEmpty {
//                    sourceModel.reloadSources()
//                }
//            }
            .navigationDestination(for: SelectionState.self) { state in
                switch state {
                    case .viewOne:
                        ViewOne()
                            .environmentObject(sourceModel)
                            .environmentObject(navigationStateManager)
                    case .viewTwo:
                        ViewTwo()
                            .environmentObject(sourceModel)
                            .environmentObject(navigationStateManager)
                    case .viewThree:
                        ViewThree()
                            .environmentObject(sourceModel)
                            .environmentObject(navigationStateManager)
                    case .accountSettings:
                        AccountSettingsView()
                            .environmentObject(sourceModel)
                            .environmentObject(navigationStateManager)
                    case .newUser:
                        NewUserView()
                            .environmentObject(navigationStateManager)
                    case .existingUser:
                        ExistingUserView()
                            .environmentObject(navigationStateManager)
                }
            }
             
        } // NavigationStack
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
