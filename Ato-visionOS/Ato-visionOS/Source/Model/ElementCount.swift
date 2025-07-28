//
//  ElementCount.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/28/25.
//

/// 화학식을 만들기 위한 정보
/// 몇 개 있는지 (e.g. H₂는 H가 2개), 산인지, 이온 화합물인지,전기음성도 (원소 순서 정렬에 필요) 등
struct ElementCount {
    let symbol: String             // 원소 기호 (예: "H", "O")
    let count: Int                 // 해당 원소의 개수
    let electronegativity: Float  // 전기음성도 값 (낮을수록 왼쪽)
    let isAcidHydrogen: Bool       // 산(HCl, H₂SO₄ 등)에서 앞에 와야 할 H 여부
    let isCation: Bool             // 이온 화합물 시 양이온 여부
    let isAnion: Bool              // 이온 화합물 시 음이온 여부
}
