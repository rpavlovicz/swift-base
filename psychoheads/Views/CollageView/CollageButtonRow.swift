import SwiftUI

struct CollageButtonRow: View {
    let onLoad: () -> Void
    let onInvert: () -> Void
    let invertEnabled: Bool
    
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
                Button(action: onInvert) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 26, weight: .regular))
                            .frame(height: 40)
                        Text("Invert")
                            .font(.caption2)
                    }
                }
                .disabled(!invertEnabled)
                .opacity(invertEnabled ? 1.0 : 0.5)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
} 
