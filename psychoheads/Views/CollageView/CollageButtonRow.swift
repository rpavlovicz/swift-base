import SwiftUI

struct CollageButtonRow: View {
    let onLoad: () -> Void
    let onAddHead: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
                //.ignoresSafeArea(edges: .bottom)
            HStack(alignment: .center) {
                Spacer()
                Button(action: onLoad) {
                    VStack(spacing: 4) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Load")
                            .font(.caption2)
                    }
                }
                Spacer()
                Button(action: onAddHead) {
                    VStack(spacing: 4) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Add Head")
                            .font(.caption2)
                    }
                }
                Spacer()
                Button(action: onMenu) {
                    VStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Menu")
                            .font(.caption2)
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
} 
