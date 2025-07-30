//
//  AtomListMockData.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/23/25.
//

import Foundation

enum AtomListMockData {
    
    //MARK: - Methods
    
    /// 전체 원자 리스트 반환 함수
    /// - Returns: [AtomSummary]
    static func allAtoms() -> [AtomSummary] {
        return mockAdList.atoms
    }
    
    
    // MARK: - Properties
    
    static let mockAdList: AtomListModel = AtomListModel(atoms: [
        AtomSummary(id: 1, symbol: "H", group: 1, period: 1),
        AtomSummary(id: 2, symbol: "He", group: 18, period: 1),
        AtomSummary(id: 3, symbol: "Li", group: 1, period: 2),
        AtomSummary(id: 4, symbol: "Be", group: 2, period: 2),
        AtomSummary(id: 5, symbol: "B", group: 13, period: 2),
        AtomSummary(id: 6, symbol: "C", group: 14, period: 2),
        AtomSummary(id: 7, symbol: "N", group: 15, period: 2),
        AtomSummary(id: 8, symbol: "O", group: 16, period: 2),
        AtomSummary(id: 9, symbol: "F", group: 17, period: 2),
        AtomSummary(id: 10, symbol: "Ne", group: 18, period: 2),
        AtomSummary(id: 11, symbol: "Na", group: 1, period: 3),
        AtomSummary(id: 12, symbol: "Mg", group: 2, period: 3),
        AtomSummary(id: 13, symbol: "Al", group: 13, period: 3),
        AtomSummary(id: 14, symbol: "Si", group: 14, period: 3),
        AtomSummary(id: 15, symbol: "P", group: 15, period: 3),
        AtomSummary(id: 16, symbol: "S", group: 16, period: 3),
        AtomSummary(id: 17, symbol: "Cl", group: 17, period: 3),
        AtomSummary(id: 18, symbol: "Ar", group: 18, period: 3),
        AtomSummary(id: 19, symbol: "K", group: 1, period: 4),
        AtomSummary(id: 20, symbol: "Ca", group: 2, period: 4)
    ])
}
