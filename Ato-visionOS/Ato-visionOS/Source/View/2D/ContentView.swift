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

    var body: some View {
        SplitPeriodicView()
            .padding(40)
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}

