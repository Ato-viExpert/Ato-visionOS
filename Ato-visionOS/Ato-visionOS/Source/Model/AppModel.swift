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
    /// selectedTool이 바뀌기전에 알려주는 역할
    /// (실험실에서 ToolType이 바뀌기 전에 확대 동작을 취소하기 위해 필요)
    var toolChangeRequest: ToolType? = nil
    let commandManager = CommandManager()
    var atomManager = AtomManager()
    var moleculeManager = MoleculeManager()
    var realityContent: RealityViewContent? = nil

}
