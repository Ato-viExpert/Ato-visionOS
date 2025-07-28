//
//  BondCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI
import RealityKit
import RealityFoundation

/// `BondCommand`는 두 원자 간의 결합을 수행하고, 이를 Undo 가능한 명령으로 관리합니다.
final class BondCommand: Command {
    
    // MARK: - Properties
    
    private let atomA: LabAtom
    private let atomB: LabAtom
    private let bondOrder: Int
    private let atomManager: AtomManager
    private let moleculeManager: MoleculeManager
    private var originalPositions: [UUID: SIMD3<Float>] = [:]
    
    // MARK: - Init
    
    /// BondCommand 초기화
    /// 두 원자(atomA, atomB) 간의 결합을 생성하고, 분자 관리자를 통해 적절한 결합 차수(bondOrder)를 계산합니다.
    /// - Parameters:
    ///   - atomA: 결합의 기준이 되는 첫 번째 원자
    ///   - atomB: 결합할 두 번째 원자
    ///   - atomManager: undo로 분자 해제 시 원자 재등록하는 원자 관리자
    ///   - moleculeManager: 결합 로직 및 분자 생성을 담당하는 분자 관리자
    init(atomA: LabAtom, atomB: LabAtom, atomManager: AtomManager,moleculeManager: MoleculeManager) {
        self.atomA = atomA
        self.atomB = atomB
        self.bondOrder = moleculeManager.predictBondOrder(atomA: atomA, atomB: atomB)
        self.atomManager = atomManager
        self.moleculeManager = moleculeManager
    }
    
    // MARK: - Public Methods
    
    /// 원자 간의 결합을 실행합니다.
    /// - Parameter content: 엔티티가 추가될 RealityViewContent 컨텍스트
    /// - Returns: 실행 결과로 생성된 Entity 배열을 포함하는 `CommandResult`
    /// - Throws: 오류 발생 시 throw됩니다.
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        let molecule = moleculeManager.createBondedAtoms(atomA: atomA, atomB: atomB)
        
        if let moleculeEntity = molecule?.entity {
            let bounds = await moleculeEntity.visualBounds(relativeTo: nil)
            let shape = await ShapeResource.generateBox(size: bounds.extents)
            await moleculeEntity.components.set(CollisionComponent(shapes: [shape]))
            await moleculeEntity.components.set(InputTargetComponent())
            await moleculeEntity.components.set(HoverEffectComponent())
            content.add(moleculeEntity)
        }
        
        guard let _ = atomA.entity, let _ = atomB.entity else { return .none }
        
        if let moleculeEntity = molecule?.entity {
            content.add(moleculeEntity)
        }
        
        if let molecule = molecule {
            for atom in molecule.atoms {
                if let entity = atom.entity {
                    originalPositions[atom.atomId] = await entity.position(relativeTo: nil)
                }
            }
        }
        
        var visited = Set<UUID>()
        assignBondedAtomPositions(root: atomA, origin: SIMD3<Float>(0, 0, 0), visited: &visited)
        
        let placedEntities = visited.compactMap { id in
            molecule?.atoms.first(where: { $0.atomId == id })?.entity
        }
        
        return .entities(placedEntities)
    }
    
    /// 실행된 결합을 취소(Undo)합니다.
    /// - Parameter content: RealityViewContent에 복원할 컨텍스트
    /// - Returns: 복원된 Entity 배열을 포함하는 `CommandResult`
    /// - Throws: 오류 발생 시 throw됩니다.
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        atomA.removeBond(Bond(atomUUID: atomB.atomId, bondType: bondOrder))
        atomB.removeBond(Bond(atomUUID: atomA.atomId, bondType: bondOrder))
        
        var restoredEntities: [Entity] = []
        
        if let molecule = moleculeManager.findMolecule(containing: atomA) {
            await molecule.entity?.removeFromParent()
            moleculeManager.unregister(molecule)
            
            let dividedClusters = moleculeManager.divideMolecule(atoms: molecule.atoms)
            
            for atoms in dividedClusters {
                if atoms.count == 1 {
                    let atom = atoms[0]
                    
                    if let entity = atom.entity,
                       let original = originalPositions[atom.atomId] {
                        await MainActor.run {
                            if entity.components[InputTargetComponent.self] == nil {
                                entity.components.set(InputTargetComponent())
                            }
                            
                            if !entity.components.has(HoverEffectComponent.self) {
                                entity.components.set(HoverEffectComponent())
                            }
                            
                            let bounds = entity.visualBounds(relativeTo: nil)
                            let shape = ShapeResource.generateSphere(radius: bounds.extents.x / 2)
                            entity.components.set(CollisionComponent(shapes: [shape]))
                            
                            content.add(entity)
                            entity.setPosition(original, relativeTo: nil)
                        }
                        
                        restoredEntities.append(entity)
                    }
                } else {
                    let newId = UUID()
                    
                    for atom in atoms {
                        atom.setMoleculeId(newId)
                    }
                    
                    let newMolecule = LabMolecule(moleculeId: newId, atoms: atoms)
                    
                    moleculeManager.register(newMolecule)
                    
                    if let moleculeEntity = newMolecule.entity {
                        await generateCollisionComponent(for: moleculeEntity, atoms: molecule.atoms)
                        await MainActor.run {
                            moleculeEntity.components.set(InputTargetComponent())
                            moleculeEntity.components.set(HoverEffectComponent())
                            content.add(moleculeEntity)
                        }
                        restoredEntities.append(moleculeEntity)
                    }
                }
            }
        }
        return .entities(restoredEntities)
    }
    
    // MARK: - Private Methods
    
    /// 결합된 원자들의 위치를 재귀적으로 배치합니다.
    /// - Parameters:
    ///   - root: 기준이 되는 원자
    ///   - origin: 기준 위치
    ///   - visited: 이미 배치한 원자의 ID 목록 (무한 재귀 방지)
    private func assignBondedAtomPositions(
        root: LabAtom,
        origin: SIMD3<Float>,
        visited: inout Set<UUID>
    ) {
        root.setPosition(origin)
        visited.insert(root.atomId)
        
        let unvisitedBonds = root.bonds.filter { !visited.contains($0.atomUUID) }
        let bondCount = root.bonds.count
        let unpairCount = root.unpairedElectrons / 2
        let totalDirections = bondCount + unpairCount
        
        guard let geometry = BondGeometry.from(totalDirections: totalDirections, bondPairs: bondCount) else {
            print("⚠️ geometry 추론 실패: \(totalDirections) pairs, \(bondCount) bonds")
            return
        }
        
        for (index, bond) in unvisitedBonds.enumerated() {
            guard let bondedAtom = root.findBondedAtom(by: bond.atomUUID, in: moleculeManager) else {
                print("⚠️ bondedAtom 못 찾음 for UUID: \(bond.atomUUID)")
                continue
            }
            
            if let entityA = atomA.entity, let entityB = atomB.entity {
                let radiusA = entityA.visualBounds(relativeTo: nil).extents.x / 2
                let radiusB = entityB.visualBounds(relativeTo: nil).extents.x / 2
                
                let overlapRatio: Float = 0.4
                let desiredDistance = (radiusA + radiusB) * (1 - overlapRatio)
                
                let direction = geometry.direction(at: index)
                let offset = direction * desiredDistance
                
                let newPosition = origin + offset
                assignBondedAtomPositions(root: bondedAtom, origin: newPosition, visited: &visited)
            }
            
        }
    }
    
    func generateCollisionComponent(for moleculeEntity: Entity, atoms: [LabAtom]) async -> CollisionComponent {
        var minPoint = SIMD3<Float>(repeating: .greatestFiniteMagnitude)
        var maxPoint = SIMD3<Float>(repeating: -.greatestFiniteMagnitude)
        
        for atom in atoms {
            guard let entity = atom.entity else { continue }
            let worldPosition = await entity.position(relativeTo: moleculeEntity)
            let radius = atom.modelScale
            
            let localMin = worldPosition - SIMD3<Float>(repeating: radius)
            let localMax = worldPosition + SIMD3<Float>(repeating: radius)
            
            minPoint = simd_min(minPoint, localMin)
            maxPoint = simd_max(maxPoint, localMax)
        }
        
        let extents = maxPoint - minPoint
        let center = (minPoint + maxPoint) / 2
        let shape = await ShapeResource.generateBox(size: extents + SIMD3<Float>(repeating: 0.01))
        
        let colliderEntity = await ModelEntity()
        
        await MainActor.run {
            colliderEntity.components.set(CollisionComponent(shapes: [shape]))
            colliderEntity.transform.translation = center
            colliderEntity.components.set(OpacityComponent(opacity: 0))
            
            moleculeEntity.addChild(colliderEntity)
        }
        return await colliderEntity.components[CollisionComponent.self]!
    }
}
