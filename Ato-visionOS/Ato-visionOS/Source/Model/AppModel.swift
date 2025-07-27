//
//  AppModel.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    let labID = "Lab"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var selectedTool: ToolType = .move
    let commandManager = CommandManager()
    var atomManager = AtomManager()
    var moleculeManager = MoleculeManager()
    var realityContent: RealityViewContent? = nil

}
