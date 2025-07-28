//
//  LabMolecule.swift
//  Ato-visionOS
//
//  Created by bongjooncha on 7/24/25.
//

import Foundation
import RealityFoundation

class LabMolecule {
    
    // MARK: - Propteries
    
    public let moleculeId: UUID /// 분자 고유 번호(동일 분자들과 결합시 구분)
    public private(set) var atoms: [LabAtom] /// 분자의 원자 목록(처음 atom은 1.안정한 원자), 2. 최소 결합을 우선순위)
    public private(set) var stable: Bool? /// 안정한 분자인지 판단
    private(set) var entity: Entity?
    public var compositionSymbol: String {
        let counts = makeElementCounts(from: atoms)
        return generateChemicalFormula(from: counts)
    }
    
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

// MARK: - 화학식 반환 관련

extension LabMolecule {
    
    /// 원자 배열에서 각 원소의 등장 횟수 및 특성을 계산해 `ElementCount` 배열로 변환합니다.
    ///  - Parameter atoms: 분자에 포함된 원자들의 배열
    ///  - Returns: 각 원소별 개수, 전기음성도, 산성 수소 여부, 이온 여부 등을 담은 `ElementCount` 리스트
    private func makeElementCounts(from atoms: [LabAtom]) -> [ElementCount] {
        let grouped = Dictionary(grouping: atoms, by: { $0.atomicNumber })
        
        return grouped.compactMap { (atomicNumber, atoms) in
            guard let atomType = AtomType.from(atomicNumber: atomicNumber) else { return nil }
            
            return ElementCount(
                symbol: atomType.symbol,
                count: atoms.count,
                electronegativity: atomType.electronegativity,
                isAcidHydrogen: atomType.isAcidHydrogen,
                isCation: atomType.isCation,
                isAnion: atomType.isAnion
            )
        }
    }
    
    /// `ElementCount` 배열을 기반으로 실제 화학식을 문자열로 생성합니다.
    /// - Parameter elements: 각 원소별 개수 및 특성 정보가 포함된 `ElementCount` 배열
    /// - Returns: 화학식 문자열 (예: "H2O", "CO2", "NaCl")
    private func generateChemicalFormula(from elements: [ElementCount]) -> String {
        var elements = elements
        
        // 산이면 H를 가장 앞으로
        if let hIndex = elements.firstIndex(where: { $0.isAcidHydrogen }) {
            let hElement = elements.remove(at: hIndex)
            elements.insert(hElement, at: 0)
        } else if elements.contains(where: { $0.isCation }) {
            // 이온 화합물이면: 양이온 → 음이온
            elements.sort {
                if $0.isCation && $1.isAnion { return true }
                if $0.isAnion && $1.isCation { return false }
                return $0.electronegativity < $1.electronegativity
            }
        } else {
            // 일반 무기화합물: 전기음성도 낮은 순
            elements.sort { $0.electronegativity < $1.electronegativity }
        }
        
        return elements.map {
            $0.count > 1 ? "\($0.symbol)\($0.count)" : $0.symbol
        }.joined()
    }
}

// MARK: - Equatable

extension LabMolecule: Equatable {
    static func == (lhs: LabMolecule, rhs: LabMolecule) -> Bool {
        lhs.moleculeId == rhs.moleculeId
    }
}
