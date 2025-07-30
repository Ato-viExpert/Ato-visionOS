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
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .task {
                    openWindow(id: appModel.labID)
                }
                .onDisappear {
                    // ContentView 윈도우가 닫히면 다른 모든 윈도우도 닫기
                    dismissWindow(id: appModel.labID)
                    Task {
                        await dismissImmersiveSpace()
                    }
                    // 앱 종료
                    exit(0)
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
