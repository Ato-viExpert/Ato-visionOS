//
//  SIMD3+.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import simd

extension SIMD3<Float> {
    /// y값을 0으로 만들어 평면에 고정시키는 프로퍼티
    var grounded: SIMD3<Float> {
        return SIMD3<Float>(x, 0, z)
    }
}
