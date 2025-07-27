//
//  LabViewModel.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/28/25.
//

import SwiftUI

@Observable
final class LabViewModel {
    
    // MARK: - Properties
    
    var currentMagnifiedAtom: LabAtom? = nil
    var selectedAtoms: [LabAtom] = []
    var initialPosition: SIMD3<Float>? = nil
    
    // MARK: - Methods
    
    func resetSelection() {
        selectedAtoms.removeAll()
    }
    
    func deselectMagnifiedAtom() {
        currentMagnifiedAtom = nil
    }
}
