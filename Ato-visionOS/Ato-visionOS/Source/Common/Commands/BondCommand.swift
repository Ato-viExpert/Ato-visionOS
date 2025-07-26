//
//  BondCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI
import RealityKit
import RealityFoundation

final class BondCommand: Command {
    
    // MARK: - Properties
    
    private let atomA: LabAtom
    private let atomB: LabAtom
    private let bondOrder: Int
    private let moleculeManager: MoleculeManager
    private var originalPositions: [UUID: SIMD3<Float>] = [:]
    
    // MARK: - Init
    
    init(atomA: LabAtom, atomB: LabAtom, bondOrder: Int, moleculeManager: MoleculeManager) {
        self.atomA = atomA
        self.atomB = atomB
        self.bondOrder = bondOrder
        self.moleculeManager = moleculeManager
    }
    
    // MARK: - Public Methods
    
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        print("✅함수 시작")
        print("🔍 atomA.sharedElectrons: \(atomA.sharedElectrons), unpaired: \(atomA.unpairedElectrons)")
        print("🔍 atomB.sharedElectrons: \(atomB.sharedElectrons), unpaired: \(atomB.unpairedElectrons)")
        
        let molecule = moleculeManager.createBondedAtoms(atomA: atomA, atomB: atomB)
        print("✅ Bond created: Molecule ID = \(String(describing: molecule?.moleculeId))")
        if let moleculeEntity = molecule?.entity {
            let bounds = await moleculeEntity.visualBounds(relativeTo: nil)
            let shape = await ShapeResource.generateBox(size: bounds.extents)
            await moleculeEntity.components.set(CollisionComponent(shapes: [shape]))
            await moleculeEntity.components.set(InputTargetComponent())
            
            content.add(moleculeEntity)
        }
        
        guard let _ = atomA.entity, let _ = atomB.entity else {
            print("❌ 엔티티를 찾을 수 없습니다.")
            return .none
        }
        
        if let moleculeEntity = molecule?.entity {
            content.add(moleculeEntity)
        }
        // 위치 백업
        //        if let molecule = molecule {
        //            for atom in molecule.atoms {
        //                if let entity = atom.entity {
        //                    originalPositions[atom.atomId] = entity.position(relativeTo: nil)
        //                }
        //            }
        //        }
        
        var visited = Set<UUID>()
        assignBondedAtomPositions(root: atomA, origin: SIMD3<Float>(0, 0, 0), visited: &visited)
        
        let placedEntities = visited.compactMap { id in
            molecule?.atoms.first(where: { $0.atomId == id })?.entity
        }
        return .entities(placedEntities)
    }
    
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        atomA.removeBond(Bond(atomUUID: atomB.atomId, bondType: bondOrder))
        atomB.removeBond(Bond(atomUUID: atomA.atomId, bondType: bondOrder))
        
        // TODO: - 관련 로직수정 필요, 위치 복원 현재 안됨
        if let molecule = moleculeManager.findMolecule(containing: atomA) {
            for atom in molecule.atoms {
                if let original = originalPositions[atom.atomId] {
                    atom.setPosition(original)
                }
            }
        }
        
        if let molecule = moleculeManager.findMolecule(containing: atomA),
           let moleculeEntity = molecule.entity {
            await moleculeEntity.removeFromParent()
        }
        
        let affectedEntities = [atomA, atomB].compactMap { $0.entity }
        return .entities(affectedEntities)
    }
    
    // MARK: - Private Methods
    
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
}
