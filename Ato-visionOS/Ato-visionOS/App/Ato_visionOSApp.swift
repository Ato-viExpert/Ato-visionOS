//
//  Ato_visionOSApp.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//


import SwiftUI

@main
struct Ato_visionOSApp: App {
    
    @State private var appModel = AppModel()
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .task {
                    openWindow(id: appModel.labID)
                }
        }
        .windowStyle(.plain)
      
        WindowGroup(id: appModel.labID) {
            LabView(viewModel: LabViewModel())
                .environment(appModel)
        }
        .windowStyle(.volumetric)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
            .onAppear {
                appModel.immersiveSpaceState = .open
            }
            .onDisappear {
                appModel.immersiveSpaceState = .closed
            }
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
