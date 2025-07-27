//
//  DeleteCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/27/25.
//

import SwiftUI
import RealityKit

final class DeleteCommand: Command {
    
    // MARK: - Properties
    
    private let targetEntity: Entity
    private let targetType: TargetType
    private var originalParent: Entity?
    private var originalPosition: SIMD3<Float>?

    private let atomManager: AtomManager
    private let moleculeManager: MoleculeManager

    enum TargetType {
        case atom(LabAtom)
        case molecule(LabMolecule)
    }
    
    // MARK: - Init

    init(target: TargetType, atomManager: AtomManager, moleculeManager: MoleculeManager) {
        self.targetType = target
        self.atomManager = atomManager
        self.moleculeManager = moleculeManager

        switch target {
        case .atom(let atom):
            self.targetEntity = atom.entity!
        case .molecule(let molecule):
            self.targetEntity = molecule.entity!
        }
    }
    
    // MARK: - Methods

    func execute(in content: RealityViewContent) async throws -> CommandResult {
        guard let parent = await targetEntity.parent else {
            print("⚠️ 삭제할 엔티티의 부모가 없습니다.")
            return .none
        }

        originalParent = parent
        originalPosition = await targetEntity.position(relativeTo: nil)

        await targetEntity.removeFromParent()

        switch targetType {
        case .atom(let atom):
            atomManager.unregister(atom)
        case .molecule(let molecule):
            moleculeManager.unregister(molecule)
        }

        return .entities([targetEntity])
    }

    func undo(in content: RealityViewContent) async throws -> CommandResult {
        guard let position = originalPosition else {
            print("⚠️ 복원 불가 - 원래 위치 정보 없음")
            return .none
        }

        await MainActor.run {
            content.add(targetEntity)
            targetEntity.setPosition(position, relativeTo: nil)
        }

        switch targetType {
        case .atom(let atom):
            atomManager.register(atom)
        case .molecule(let molecule):
            moleculeManager.register(molecule)
        }

        return .entities([targetEntity])
    }
}
