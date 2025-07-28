//
//  String+.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/28/25.
//

extension String {
    var subscripted: String {
        let subscripts: [Character: Character] = [
            "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄",
            "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉"
        ]
        return self.map { String(subscripts[$0] ?? $0) }.joined()
    }
}
