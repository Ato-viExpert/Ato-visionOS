//
//  AtomListModel.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/23/25.
//

import Foundation

struct AtomListModel {
    let atoms: [AtomSummary]
}

struct AtomSummary: Identifiable {
    let id: Int           // 원자 번호
    let symbol: String    // "H", "He", "Li", ...
    let group: Int        // 주기율표 세로 족
    let period: Int       // 주기율표 가로 주기
}


