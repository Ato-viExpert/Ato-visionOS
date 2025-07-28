//
//  ContentView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var splitSize: CGSize = .zero //CGSize(width: 1200, height: 800)

    
    var body: some View {
        ZStack(alignment: .bottom) {
            SplitPeriodicView()
                .padding(.bottom, 40)
                .frame(minWidth: 900, minHeight: 600)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 55))
                .padding(.bottom, 35)
                .onPreferenceChange(SplitViewWindowSizeKey.self) { newSize in
                    splitSize = newSize
                }
            
        }
        .frame(minWidth: 1250, minHeight: 650)
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}
