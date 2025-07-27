//
//  SpawnAtomCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/16/25.
//

import SwiftUI
import RealityKit

/// 주어진 원자 타입(AtomType)에 해당하는 LabAtom을 생성하고 씬에 추가하는 커맨드입니다.
/// 실행 시 새로운 LabAtom 엔티티를 생성하거나 기존 생성된 엔티티를 재추가하고,
/// undo 시 해당 엔티티를 씬에서 제거합니다.
final class SpawnAtomCommand: Command {
    // MARK: - Properties
    
    private let atomType: AtomType
    private var spawnedAtom: LabAtom?
    private var spawnedEntity: Entity?
    private let atomManager: AtomManager

    // MARK: - Init
    
    /// SpawnAtomCommand 초기화
    /// - Parameter atomType: 생성할 LabAtom의 원소 타입
    init(atomType: AtomType, atomManager: AtomManager) {
        self.atomType = atomType
        self.atomManager = atomManager
    }

    // MARK: - Methods
    
    /// LabAtom을 생성하여 RealityViewContent에 추가합니다.
    /// 이미 생성된 엔티티가 있다면 재사용하여 다시 추가합니다.
    /// - Parameter content: RealityView에 배치된 RealityViewContent
    /// - Returns: 생성된 LabAtom 엔티티를 포함한 CommandResult
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        if let entity = spawnedEntity, let atom = spawnedAtom {
            content.add(entity)
            atomManager.register(atom)
            return .entity(entity)
        }
        
        let atom = LabAtom(atomicNumber: atomType.atomicNumber)
        let entity = try await atom.loadEntity()

        spawnedAtom = atom
        spawnedEntity = entity
        content.add(entity)
        atomManager.register(atom)
        
        return .entity(entity)
    }

    /// RealityViewContent 내에서 생성한 LabAtom 엔티티를 제거하여 undo를 수행합니다.
    /// - Parameter content: RealityView에 배치된 RealityViewContent
    /// - Returns: 제거된 LabAtom 엔티티를 포함한 CommandResult
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        guard let entity = spawnedEntity, let atom = spawnedAtom else { return .none }
        await entity.removeFromParent()
        atomManager.unregister(atom)
        return .entity(entity)
    }
}
