//
//  DissociateCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI
import RealityKit
import RealityFoundation

/// `DissociateCommand`는 두 원자의 결합을 해제하고 개별 원자로 복원하는 명령입니다.
final class DissociateCommand: Command {
    
    // MARK: - Properties
    
    private let atomA: LabAtom
    private let atomB: LabAtom
    private let moleculeManager: MoleculeManager
    private var bondOrder: Int = 1
    private var originalMoleculeEntity: Entity?
    private var originalPositions: [UUID: SIMD3<Float>] = [:]
    
    // MARK: - Init
    
    /// DissociateCommand 초기화
    /// - Parameters:
    ///   - atomA: 결합된 첫 번째 원자
    ///   - atomB: 결합된 두 번째 원자
    ///   - moleculeManager: 결합 및 분리 로직을 담당하는 분자 관리자
    init(atomA: LabAtom, atomB: LabAtom, moleculeManager: MoleculeManager) {
        self.atomA = atomA
        self.atomB = atomB
        self.moleculeManager = moleculeManager
    }
    
    // MARK: - Public Methods
    
    /// 원자 간 결합을 해제하고, 새로운 분자 또는 개별 원자 엔티티로 분리하여 RealityView에 다시 추가합니다.
    ///  - Parameter content: RealityView에 접근하기 위한 RealityViewContent 인스턴스
    ///  - Returns: 새로 복원되거나 생성된 Entity 목록을 담은 CommandResult
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        guard let molecule = moleculeManager.findMolecule(containing: atomA),
              molecule.atoms.contains(where: { $0.atomId == atomB.atomId }) else {
            print("⚠️ 두 원자가 같은 분자에 있지 않음")
            return .none
        }
        
        self.bondOrder = moleculeManager.predictBondOrder(atomA: atomA, atomB: atomB)
        originalMoleculeEntity = molecule.entity
        
        for atom in molecule.atoms {
            if let entity = atom.entity {
                originalPositions[atom.atomId] = await entity.position(relativeTo: nil)
            }
        }
        
        atomA.removeBond(Bond(atomUUID: atomB.atomId, bondType: bondOrder))
        atomB.removeBond(Bond(atomUUID: atomA.atomId, bondType: bondOrder))
        
        await molecule.entity?.removeFromParent()
        moleculeManager.unregister(molecule)
        
        let dividedClusters = moleculeManager.divideMolecule(atoms: molecule.atoms)
        var restoredEntities: [Entity] = []
        
        for atoms in dividedClusters {
            if atoms.count == 1 {
                let atom = atoms[0]
                if let entity = atom.entity,
                   let position = originalPositions[atom.atomId] {
                    
                    let offset: Float = 0.05
                    let adjustedPosition: SIMD3<Float>
                    if atom.atomId == atomA.atomId {
                        adjustedPosition = SIMD3<Float>(position.x - offset, position.y, position.z)
                    } else {
                        adjustedPosition = SIMD3<Float>(position.x + offset, position.y, position.z)
                    }
                    
                    await MainActor.run {
                        if entity.components[InputTargetComponent.self] == nil {
                            entity.components.set(InputTargetComponent())
                        }
                        
                        let bounds = entity.visualBounds(relativeTo: nil)
                        let shape = ShapeResource.generateSphere(radius: bounds.extents.x / 2)
                        entity.components.set(CollisionComponent(shapes: [shape]))
                        
                        content.add(entity)
                        entity.setPosition(adjustedPosition, relativeTo: nil)
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
                    await MainActor.run {
                        let bounds = moleculeEntity.visualBounds(relativeTo: nil)
                        let shape = ShapeResource.generateBox(size: bounds.extents)
                        moleculeEntity.components.set(CollisionComponent(shapes: [shape]))
                        moleculeEntity.components.set(InputTargetComponent())
                        content.add(moleculeEntity)
                    }
                    
                    restoredEntities.append(moleculeEntity)
                }
            }
        }
        return .entities(restoredEntities)
    }
    
    /// 결합을 복원하고 원자들을 다시 하나의 분자로 구성합니다.
    /// - Parameter content: RealityView의 콘텐츠. entity를 추가하거나 제거하는 데 사용됩니다.
    /// - Returns: 복원된 molecule entity 또는 아무 것도 없을 경우 `.none` 반환
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        atomA.addBond(Bond(atomUUID: atomB.atomId, bondType: bondOrder))
        atomB.addBond(Bond(atomUUID: atomA.atomId, bondType: bondOrder))

        let newMolecule = moleculeManager.createBondedAtoms(atomA: atomA, atomB: atomB)

        for atom in newMolecule?.atoms ?? [] {
            if let entity = atom.entity,
               let position = originalPositions[atom.atomId] {
                await MainActor.run {
                    entity.setPosition(position, relativeTo: nil)
                }
            }
        }
        
        if let molecule = newMolecule, let moleculeEntity = molecule.entity {
            moleculeManager.register(molecule)
            
            if let firstAtom = molecule.atoms.first,
               let restoredPosition = originalPositions[firstAtom.atomId] {
                await MainActor.run {
                    // TODO: - 위치 오류 수정
                    moleculeEntity.setPosition(restoredPosition, relativeTo: nil)
                }
            }

            await MainActor.run {
                content.add(moleculeEntity)
            }

            return .entity(moleculeEntity)
        } else {
            return .none
        }
    }
}
