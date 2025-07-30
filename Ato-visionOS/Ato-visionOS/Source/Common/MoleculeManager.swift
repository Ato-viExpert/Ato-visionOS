//
//  MoleculeManager.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/27/25.
//

import SwiftUI

@Observable
final class MoleculeManager {
    
    // MARK: - Properties
    
    private(set) var molecules: [LabMolecule] = []
    var selectedMolecule: LabMolecule? = nil {
        didSet {
            if let molecule = selectedMolecule {
                print("✅ 선택된 분자 변경됨: \(molecule.compositionSymbol)")
            } else {
                print("🟡 선택된 분자가 nil로 변경됨")
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// 선택된 Molecule세팅
    /// - Parameter molecule: LabMolecule
    func selectMolecule(_ molecule: LabMolecule) {
        selectedMolecule = molecule
    }
    
    /// 전체 분자 반환
    /// - Returns: [LabMolecule]
    func allMoleculesList() -> [LabMolecule] {
        return molecules
    }
    
    /// 주어진 원자를 포함하는 분자를 찾아 반환합니다.
    /// - Parameter atom: 해당 atom을 포함한 분자를 찾습니다.
    /// - Returns: atom이 속한 LabMolecule 또는 nil
    public func findMolecule(containing atom: LabAtom) -> LabMolecule? {
        return molecules.first(where: { $0.atoms.contains(where: { $0.atomId == atom.atomId }) })
    }
    
    /// UUID에 해당하는 분자를 찾아 반환합니다.
    ///  - Parameter uuid: 찾고자 하는 LabMolecule의 고유 식별자
    ///  - Returns: 해당 UUID를 가진 LabMolecule, 없으면 nil
    func findMoleculeByUUID(_ uuid: UUID) -> LabMolecule? {
        return molecules.first(where: { $0.moleculeId == uuid })
    }
    
    /// 새로운 분자를 등록합니다.
    ///  - Parameter molecule: 등록할 LabMolecule
    func register(_ molecule: LabMolecule) {
        if !molecules.contains(where: { $0.moleculeId == molecule.moleculeId }) {
            molecules.append(molecule)
            selectedMolecule = molecule
        }
    }
    
    /// 분자 등록을 해제합니다.
    /// - Parameter molecule: 제거할 LabMolecule
    func unregister(_ molecule: LabMolecule) {
        molecules.removeAll { $0.moleculeId == molecule.moleculeId }
    }
    
    /// 두 원자를 결합하여 새로운 분자를 생성합니다.
    ///  - Parameters:
    ///    - atomA: 결합 대상 첫 번째 원자
    ///    - atomB: 결합 대상 두 번째 원자
    ///  - Returns: 결합된 결과로 생성된 LabMolecule, 결합 실패 시 nil
    func createBondedAtoms(atomA: LabAtom, atomB: LabAtom) -> LabMolecule? {
        let bondOrder = predictBondOrder(atomA: atomA, atomB: atomB)
        guard bondOrder > 0 else {
            wrongChoice()
            return nil
        }
        
        atomA.addBond(Bond(atomUUID: atomB.atomId, bondType: bondOrder))
        atomB.addBond(Bond(atomUUID: atomA.atomId, bondType: bondOrder))
        
        if atomA.moleculeId == nil && atomB.moleculeId == nil {
            let newUUID = UUID()
            atomA.setMoleculeId(newUUID)
            atomB.setMoleculeId(newUUID)
            
            let molecule = LabMolecule(moleculeId: newUUID, atoms: [atomA, atomB])
            molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
            register(molecule)
            return molecule
        }
        
        // atomA는 고립, atomB는 분자 소속 → atomA를 atomB 분자로
        if atomA.moleculeId == nil, let moleculeId = atomB.moleculeId,
           let molecule = findMoleculeByUUID(moleculeId) {
            atomA.setMoleculeId(moleculeId)
            molecule.addAtom(atomA)
            molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
            return molecule
        }
        
        // atomB는 고립, atomA는 분자 소속 → atomB를 atomA 분자로
        if atomB.moleculeId == nil, let moleculeId = atomA.moleculeId,
           let molecule = findMoleculeByUUID(moleculeId) {
            atomB.setMoleculeId(moleculeId)
            molecule.addAtom(atomB)
            molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
            return molecule
        }
        
        // 둘 다 분자 소속이고, 다른 분자일 경우 → 병합
        if let uuidA = atomA.moleculeId,
           let uuidB = atomB.moleculeId,
           uuidA != uuidB,
           let moleculeA = findMoleculeByUUID(uuidA),
           let moleculeB = findMoleculeByUUID(uuidB) {
            changeMoleculeState(moleculeA: moleculeA, moleculeB: moleculeB)
            unregister(moleculeB)
            return moleculeA
        }
        
        // 동일한 분자 소속이면 안정성만 갱신
        if let uuid = atomA.moleculeId,
           uuid == atomB.moleculeId,
           let molecule = findMoleculeByUUID(uuid) {
            molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
            return molecule
        }
        
        return nil
    }
    
    /// 원자 결합 예측
    /// - Parameters:
    ///   - atomA: 결합할 LabAtom 1
    ///   - atomB: 결합할 LabAtom 2
    /// - Returns: 두개의 원자가 결합 할 경우 몇 중 결합을 하게 되는지(불가일 경우 0)
    func predictBondOrder(atomA: LabAtom, atomB: LabAtom) -> Int {
        // 조건 1: 남은 홑전자가 있어야 함
        guard atomA.unpairedElectrons > 0, atomB.unpairedElectrons > 0 else {
            return 0
        }
        
        // 조건 2: 현재 전자 수가 옥텟 이상이면 더 이상 결합 불가
        guard atomA.currentElectronCount < atomA.maxElectronCount,
              atomB.currentElectronCount < atomB.maxElectronCount else {
            return 0
        }
        
        let needA = atomA.maxElectronCount - atomA.currentElectronCount
        let needB = atomB.maxElectronCount - atomB.currentElectronCount
        
        let maxPossibleBond = min(atomA.unpairedElectrons, atomB.unpairedElectrons)
        let requiredBond = min(needA, needB, 3)
        
        return min(maxPossibleBond, requiredBond)
    }
    
    /// 주어진 원자 리스트에서 결합된 원자 그룹들을 분리하여 반환합니다.
    /// DFS를 이용해 연결된 원자들끼리 하나의 군집으로 묶습니다.
    /// - Parameter atoms: 분할할 전체 원자 배열
    /// - Returns: 각 연결된 군집을 원소로 가지는 2차원 배열 (ex. [[LabAtom], [LabAtom, LabAtom], ...])
    func divideMolecule(atoms: [LabAtom]) -> [[LabAtom]] {
        var visited = Set<UUID>()
        var result: [[LabAtom]] = []
        
        for atom in atoms {
            if visited.contains(atom.atomId) { continue }
            var cluster: [LabAtom] = []
            dfs(atom, atoms, &visited, &cluster)
            result.append(cluster)
        }
        
        return result
    }
    
    // MARK: - Private Methods
    
    
    /// 원자의 결합 상태 변화(결합, 결합 전자 수, 홀전자 수 변화)
    /// - Parameters:
    ///   - atomA: 원자 A
    ///   - atomB: 원자 B
    ///   - bond: 몇 중 결합인지 Int 값
    private func changeAtomState(atomA: LabAtom, atomB: LabAtom, bond: Int) {
        atomA.addBond(Bond(atomUUID: atomB.atomId, bondType: bond))
        atomB.addBond(Bond(atomUUID: atomA.atomId, bondType: bond))
    }
    
    /// 원자의 분자 고유 번호 변화
    /// - Parameters:
    ///   - atom: 원자
    ///   - moleculeId: 원자에 분자 id 세팅
    private func changeAtomUUID(atom: LabAtom, moleculeId: UUID) {
        atom.setMoleculeId(moleculeId)
    }
    
    /// 분자 안정성 판단
    /// - Parameter molecule: 분자
    /// - Returns: 분자의 안전성 여부 반환
    private func checkMoleculeStable(molecule: LabMolecule) -> Bool {
        for atom in molecule.atoms {
            if atom.unpairedElectrons > 0 || atom.currentElectronCount > atom.maxElectronCount {
                return false
            }
        }
        return true
    }
    
    /// 분자 생성(원자 2개가 결합할 경우)
    /// - Parameters:
    ///   - atomA: 원자 A
    ///   - atomB: 원자 B
    ///   - bond: 결합 정보 (분자 id, 결합 1, 2, 3 중 무엇인지)
    /// - Returns: 분자
    private func createMolecule(atomA: LabAtom, atomB: LabAtom, bond: Int) -> LabMolecule {
        let bondedA = atomA
        let bondedB = atomB
        bondedA.addBond(Bond(atomUUID: bondedB.atomId, bondType: bond))
        bondedB.addBond(Bond(atomUUID: bondedA.atomId, bondType: bond))
        
        let moleculeId = UUID()
        bondedA.setMoleculeId(moleculeId)
        bondedB.setMoleculeId(moleculeId)
        
        let molecule = LabMolecule(moleculeId: moleculeId, atoms: [bondedA, bondedB])
        molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
        
        return molecule
    }
    
    /// 분자 상태 변화(기존 분자에 새로운 원자 추가)
    /// - Parameters:
    ///   - atom: 원자, 분자
    ///   - molecule: 분자
    private func changeMoleculeState(atom: LabAtom, molecule: LabMolecule) {
        atom.setMoleculeId(molecule.moleculeId)
        molecule.addAtom(atom)
        molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
    }
    
    /// 분자 상태 변화(분자 두개 한개로 합치기)
    /// - Parameters:
    ///   - moleculeA: 분자, 분자
    ///   - moleculeB: 분자
    private func changeMoleculeState(moleculeA: LabMolecule, moleculeB: LabMolecule) {
        for atom in moleculeB.atoms {
            atom.setMoleculeId(moleculeA.moleculeId)
            moleculeA.addAtom(atom)
        }
        
        moleculeA.updateStableStatus(checkMoleculeStable(molecule: moleculeA))
    }
    
    /// 깊이 우선 탐색을 통해 연결된 원자들을 하나의 군집(cluster)으로 수집합니다.
    /// - Parameters:
    ///   - atom: 탐색을 시작할 현재 원자
    ///   - atoms: 전체 원자 리스트
    ///   - visited: 이미 방문한 원자의 ID 집합
    ///   - cluster: 현재 군집에 포함된 원자들을 누적할 배열
    private func dfs(_ atom: LabAtom, _ atoms: [LabAtom], _ visited: inout Set<UUID>, _ cluster: inout [LabAtom]) {
        visited.insert(atom.atomId)
        cluster.append(atom)
        for bond in atom.bonds {
            if let next = atoms.first(where: { $0.atomId == bond.atomUUID }),
               !visited.contains(next.atomId) {
                dfs(next, atoms, &visited, &cluster)
            }
        }
    }
    
    /// 결합 불가능한 경우 처리
    /// - Returns: 에러처리
    private func wrongChoice() {
        NotificationCenter.default.post(name: .bondingFailed, object: nil, userInfo: ["message": "결합 불가"])
    }
}
