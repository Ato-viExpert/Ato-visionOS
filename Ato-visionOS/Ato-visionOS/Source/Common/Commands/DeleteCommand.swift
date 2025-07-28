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
    
    /// DeleteCommand 초기화
    /// - Parameters:
    ///   - target: 삭제 대상 (원자 또는 분자)
    ///   - atomManager: 원자 등록/해제 관리를 위한 매니저
    ///   - moleculeManager: 분자 등록/해제 관리를 위한 매니저
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

    /// 선택된 엔티티를 씬에서 제거하고 관련 매니저에서 등록 해제합니다.
    /// - Parameter content: RealityView의 컨텍스트
    /// - Returns: 제거된 엔티티 리스트
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        guard let parent = await targetEntity.parent else { return .none }

        originalParent = parent
        originalPosition = await targetEntity.position(relativeTo: nil)

        await targetEntity.removeFromParent()

        switch targetType {
        case .atom(let atom):
            atomManager.unregister(atom)
        case .molecule(let molecule):
            for atom in molecule.atoms {
                atomManager.unregister(atom)
            }
            moleculeManager.unregister(molecule)
        }

        return .entities([targetEntity])
    }

    /// 삭제를 취소하고 원래 위치에 엔티티를 복원합니다.
    ///  - Parameter content: RealityView의 컨텍스트
    ///  - Returns: 복원된 엔티티 리스트
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        guard let position = originalPosition else { return .none }

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
