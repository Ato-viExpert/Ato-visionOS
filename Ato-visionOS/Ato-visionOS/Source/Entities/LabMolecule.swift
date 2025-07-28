//
//  LabMolecule.swift
//  Ato-visionOS
//
//  Created by bongjooncha on 7/24/25.
//

import Foundation
import RealityFoundation

class LabMolecule{
    // MARK: - Propteries
    
    public let moleculeId: UUID /// 분자 고유 번호(동일 분자들과 결합시 구분)
    public private(set) var atoms: [LabAtom] /// 분자의 원자 목록(처음 atom은 1.안정한 원자), 2. 최소 결합을 우선순위)
    public private(set) var stable: Bool? /// 안정한 분자인지 판단
    private(set) var entity: Entity?
    
    // MARK: - Init
    
    init(moleculeId: UUID, atoms: [LabAtom]) {
        self.moleculeId = moleculeId
        self.atoms = atoms
        self.stable = nil
        
        let container = Entity()
        for atom in atoms {
            if let atomEntity = atom.entity {
                container.addChild(atomEntity)
            }
        }
        self.entity = container
    }
    
    // MARK: - Public Methods
    
    /// 분자에 원자 추가
    func addAtom(_ atom: LabAtom) {
        atoms.append(atom)
        if let atomEntity = atom.entity {
            self.entity?.addChild(atomEntity)
        }
    }
    
    /// 안정성 상태 업데이트
    func updateStableStatus(_ isStable: Bool) {
        self.stable = isStable
    }
    
    func setInteractionMode(for tool: ToolType) {
        switch tool {
        case .bond, .dissociate:
            // 개별 원자 클릭 허용
            atoms.forEach { atom in
                atom.entity?.components.set(InputTargetComponent())
            }
            self.entity?.components.remove(InputTargetComponent.self)
            
        default:
            // 전체 분자 클릭 허용 (원자는 막기)
            atoms.forEach { atom in
                atom.entity?.components.remove(InputTargetComponent.self)
            }
            self.entity?.components.set(InputTargetComponent())
        }
    }
}
