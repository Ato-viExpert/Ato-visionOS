//
//  AtomType.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI

enum AtomType: String, CaseIterable {
    case H, He
    case Li, Be, B, C, N, O, F, Ne
    case Na, Mg, Al, Si, P, S, Cl, Ar
    case K, Ca
    case Br, I
    
    /// 원자 부호
    var symbol: String { String(describing: self) }
    
    /// 원자 이름 -> 수소, Hydrogen 다국어 지원
    var localizedName: LocalizedStringKey {
        return LocalizedStringKey("atom.name.\(self.rawValue)")
    }
    
    /// 원자 번호
    var atomicNumber: Int {
        switch self {
        case .H: return 1
        case .He: return 2
        case .Li: return 3
        case .Be: return 4
        case .B: return 5
        case .C: return 6
        case .N: return 7
        case .O: return 8
        case .F: return 9
        case .Ne: return 10
        case .Na: return 11
        case .Mg: return 12
        case .Al: return 13
        case .Si: return 14
        case .P: return 15
        case .S: return 16
        case .Cl: return 17
        case .Ar: return 18
        case .K: return 19
        case .Ca: return 20
        case .Br: return 35
        case .I: return 53
        }
    }

    /// 각 껍질별 최대 전자 수
    private var maxElectronsPerOrbit: [Int] {
        [2, 8, 8, 18, 18, 32, 32]
    }


    /// 전자 껍질 
    var orbit: Int {
        switch atomicNumber {
        case 1...2: return 1
        case 3...10: return 2
        case 11...18: return 3
        case 19...36: return 4
        case 37...54: return 5
        case 55...86: return 6
        case 87...118: return 7
        default: return 0
        }
    }

    // 각 껍질별 실제 전자 수 계산
    var electronsPerOrbit: [Int] {
        var remainingElectrons = atomicNumber
        var result = [Int]()
        
        for shellMax in maxElectronsPerOrbit {
            if remainingElectrons <= 0 { break }
            let shellElectrons = min(remainingElectrons, shellMax)
            result.append(shellElectrons)
            remainingElectrons -= shellElectrons
        }
        
        return result
    }
    
    // 최외각 전자 수
    var valenceElectrons: Int {
        electronsPerOrbit.last ?? 0
    }
    
    // 족(group) 계산
    var group: Int {
        switch atomicNumber {
        case 1, 3, 11, 19, 37, 55, 87: return 1  // 1족 (알칼리 금속)
        case 4, 12, 20, 38, 56, 88: return 2  // 2족 (알칼리 토금속)
        case 21...30: return atomicNumber - 18  // 3족-12족 (전이금속)
        case 39...48: return atomicNumber - 36  // 3족-12족
        case 57...80: return atomicNumber - 54  // 3족-12족
        case 5, 13, 31, 49, 81, 113: return 13  // 13족 (붕소족)
        case 6, 14, 32, 50, 82, 114: return 14  // 14족 (탄소족)
        case 7, 15, 33, 51, 83, 115: return 15  // 15족 (질소족)
        case 8, 16, 34, 52, 84, 116: return 16  // 16족 (산소족)
        case 9, 17, 35, 53, 85, 117: return 17  // 17족 (할로젠)
        case 2, 10, 18, 36, 54, 86, 118: return 18  // 18족 (비활성 기체)
        case 57...71: return 3  // 란타넘족 (모두 3족으로 처리)
        case 89...103: return 3 // 악티늄족 (모두 3족으로 처리)
        default: return 0
        }
    }


    /// 중성자수
    var neutronCount: Int {
        switch self {
        case .H: return 1
        case .He: return 2
        case .Li: return 4
        case .Be: return 5
        case .B: return 6
        case .C: return 6
        case .N: return 7
        case .O: return 8
        case .F: return 10
        case .Ne: return 10
        case .Na: return 12
        case .Mg: return 12
        case .Al: return 14
        case .Si: return 14
        case .P: return 16
        case .S: return 16
        case .Cl: return 18
        case .Ar: return 22
        case .K: return 20
        case .Ca: return 20
        case .Br: return 45
        case .I: return 74
        }
    }
    
    /// 원자 크기
    var modelScale: Float {
        switch self {
        case .H: return 1.500
        case .He: return 1.689
        case .Li: return 2.250
        case .Be: return 2.174
        case .B: return 2.061
        case .C: return 1.948
        case .N: return 1.911
        case .O: return 1.875
        case .F: return 1.875
        case .Ne: return 1.800
        case .Na: return 2.446
        case .Mg: return 2.321
        case .Al: return 2.286
        case .Si: return 2.250
        case .P: return 2.214
        case .S: return 2.174
        case .Cl: return 2.138
        case .Ar: return 2.061
        case .K: return 2.625
        case .Ca: return 2.554
        case .Br: return 2.700
        case .I: return 2.928
        }
    }
    
    /// diffuse Color
    /// 원자 기본 색상
    var diffuseColor: UIColor {
        switch self {
        case .H: return UIColor(hex: "#6DC0FF")
        case .He: return UIColor(hex: "#B6F8FF")
        case .Li: return UIColor(hex: "#57FFBE")
        case .Be: return UIColor(hex: "#C17CFF")
        case .B: return UIColor(hex: "#FF77C2")
        case .C: return UIColor(hex: "#000000")
        case .N: return UIColor(hex: "#0535FF")
        case .O: return UIColor(hex: "#FF4884")
        case .F: return UIColor(hex: "#FF7800")
        case .Ne: return UIColor(hex: "#FFADF7")
        case .Na: return UIColor(hex: "#004820")
        case .Mg: return UIColor(hex: "#E2D8FF")
        case .Al: return UIColor(hex: "#FF02A9")
        case .Si: return UIColor(hex: "#000000")
        case .P: return UIColor(hex: "#061CFF")
        case .S: return UIColor(hex: "#FFF000")
        case .Cl: return UIColor(hex: "#4C9D00")
        case .Ar: return UIColor(hex: "#FFE7AB")
        case .K: return UIColor(hex: "#00FF6A")
        case .Ca: return UIColor(hex: "#FF4884")
        case .Br: return UIColor(hex: "#FFB55F")
        case .I: return UIColor(hex: "#C5FF17")
        }
    }
    
    /// emissive Color
    /// 원자 발광 색상
    var emissiveColor: UIColor {
        switch self {
        case .H: return UIColor(hex: "#0072FF")
        case .He: return UIColor(hex: "#31E3FF")
        case .Li: return UIColor(hex: "#00FF9A")
        case .Be: return UIColor(hex: "#8D00FF")
        case .B: return UIColor(hex: "#FFA1EC")
        case .C: return UIColor(hex: "#000000")
        case .N: return UIColor(hex: "#7CB3FF")
        case .O: return UIColor(hex: "#FF0000")
        case .F: return UIColor(hex: "#FF8F50")
        case .Ne: return UIColor(hex: "#FFD5D0")
        case .Na: return UIColor(hex: "#008409")
        case .Mg: return UIColor(hex: "#8E00FF")
        case .Al: return UIColor(hex: "#FF008E")
        case .Si: return UIColor(hex: "#6E6F6F")
        case .P: return UIColor(hex: "#9341FF")
        case .S: return UIColor(hex: "#FF951E")
        case .Cl: return UIColor(hex: "#2DFF00")
        case .Ar: return UIColor(hex: "#FFD5A8")
        case .K: return UIColor(hex: "#009400")
        case .Ca: return UIColor(hex: "#8D22FF")
        case .Br: return UIColor(hex: "#55422C")
        case .I: return UIColor(hex: "#00C865")
        }
    }
}

extension AtomType {
    
    // MARK: - Methods
    
    /// 원자번호로 AtomType 매칭
    /// - Parameter atomicNumber: 원자 번호 Int 값
    /// - Returns: 원자번호와 일치하는 AtomType
    static func from(atomicNumber: Int) -> AtomType? {
        let map: [Int: AtomType] = [
            1: .H, 2: .He, 3: .Li, 4: .Be, 5: .B,
            6: .C, 7: .N, 8: .O, 9: .F, 10: .Ne,
            11: .Na, 12: .Mg, 13: .Al, 14: .Si, 15: .P,
            16: .S, 17: .Cl, 18: .Ar, 19: .K, 20: .Ca,
            35: .Br, 53: .I
        ]
        return map[atomicNumber]
    }
    
    /// 원자기호로 AtomType 매칭
    /// - Parameter symbol: 원자 기호 (예: "H", "O", "Na")
    /// - Returns: AtomType 또는 nil
    static func from(symbol: String) -> AtomType? {
        return AtomType.allCases.first(where: { $0.symbol == symbol })
    }
}


// MARK: - 화학식 생성 ElementCount에 넣기 위해 필요한 값
extension AtomType {
    /// 파울링 전기음성도
    var electronegativity: Float {
        switch self {
        case .F: return 3.98
        case .O: return 3.44
        case .Cl: return 3.16
        case .N: return 3.04
        case .Br: return 2.96
        case .I: return 2.66
        case .S: return 2.58
        case .C: return 2.55
        case .P: return 2.19
        case .H: return 2.20
        case .Si: return 1.90
        case .B: return 2.04
        case .Be: return 1.57
        case .Al: return 1.61
        case .Mg: return 1.31
        case .Na: return 0.93
        case .K: return 0.82
        case .Ca: return 1.00
        case .Li: return 0.98
        case .He, .Ne, .Ar: return 0.0
        }
    }
    
    /// 산의 조건에 따라 앞에 오는 H 여부
    var isAcidHydrogen: Bool {
        return self == .H
    }
    
    /// 금속 여부 기반으로 양이온 여부
    var isCation: Bool {
        return [.Na, .K, .Ca, .Mg, .Li, .Be, .Al].contains(self)
    }

    /// 비금속 중 전형적인 음이온
    var isAnion: Bool {
        return [.Cl, .Br, .I, .O, .F, .S].contains(self)
    }
}
