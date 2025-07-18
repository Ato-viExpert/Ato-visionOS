//
//  ToolType.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI

enum ToolGroup {
    case selectable, action
}

enum ToolType: CaseIterable, Equatable {
    case move, magnify, bond, dissociate, erase
    case undo, redo
    
    var group: ToolGroup {
        switch self {
        case .undo, .redo: return .action
        default: return .selectable
        }
    }
    
    // TODO: - ImageResource 변경 필요
    var icon: ImageResource {
        switch self {
        case .move:
            return .icObserve
        case .magnify:
            return .icObserve
        case .bond:
            return .icConnet
        case .dissociate:
            return .icDisconnect
        case .erase:
            return .icDelete
        case .undo:
            return .icNext
        case .redo:
            return .icBack
        }
    }
}
