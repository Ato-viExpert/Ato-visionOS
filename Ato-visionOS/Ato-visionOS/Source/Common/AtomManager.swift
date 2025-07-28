//
//  AtomManager.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/27/25.
//

import Foundation

final class AtomManager {
    // MARK: - Properties
    
    private var atoms: [UUID: LabAtom] = [:]
    
    // MARK: - Public Methods
    
    /// atoms(실험실에 나와있는 원자리스트)에서 원자 등록
    /// - Parameter atom: LabAtom
    func register(_ atom: LabAtom) {
        atoms[atom.atomId] = atom
    }
    
    /// atoms(실험실에 나와있는 원자리스트)에서 원자 제거
    /// - Parameter atom: LabAtom
    func unregister(_ atom: LabAtom) {
        atoms.removeValue(forKey: atom.atomId)
    }
    
    /// name(String)으로 LabAtom 찾기
    /// - Parameter entityName: 원자 이름 String 값
    /// - Returns: LabAtom
    func findAtom(by entityName: String) -> LabAtom? {
        let normalizedName: String
        if entityName.hasPrefix("magnified_") {
            normalizedName = String(entityName.dropFirst("magnified_".count))
        } else {
            normalizedName = entityName
        }
        return atoms.values.first(where: { $0.atomId.uuidString == normalizedName })
    }

    /// 전체 원자 반환
    /// - Returns: [LabAtom]
    func allAtoms() -> [LabAtom] {
        return Array(atoms.values)
    }
}
