//
//  ElementData.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import Foundation

// 주기율표 구조
// MARK: - Symbol Grid Layout

/// 화면에 주기율표를 시각적으로 배열하기 위한 원소 기호의 2차원 배열입니다.
/// 빈 문자열("")은 시각적으로 비워야 할 칸을 의미하며, 각 기호는 `elementInfoDict`의 키와 일치해야 합니다.
let symbolGrid: [[String]] = [
    ["H", "", "", "", "", "", "", "He"],
    ["Li", "Be", "B", "C", "N", "O", "F", "Ne"],
    ["Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar"],
    ["K", "Ca", "", "", "", "", "Br", ""],
    ["", "", "", "", "", "", "I", ""]
]
