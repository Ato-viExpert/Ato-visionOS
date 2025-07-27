//
//  BondGeometry.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityKit

enum BondGeometry {
        case linear
        case bent_3
        case bent_4
        case trigonalPlanar
        case trigonalPyramidal
        case tetrahedral
        case trigonalBipyramidal
        case seeSaw
        case tShape
        case octahedral
        case squarePyramidal
        case squarePlanar
        case pentagonalBipyramidal
        case distortedOctahedral
    
    static func from(totalDirections: Int, bondPairs: Int) -> BondGeometry? {
        switch (totalDirections, bondPairs) {
        case (1, 0), (1, 1): return .linear
        case (2, 2): return .linear
        case (2, 1): return .linear
        case (2, 0): return .linear
            
        case (3, 3): return .trigonalPlanar
        case (3, 2): return .bent_3
        case (3, 1): return .bent_3
        case (3, 0): return .trigonalPlanar
            
        case (4, 4): return .tetrahedral
        case (4, 3): return .trigonalPyramidal
        case (4, 2): return .bent_4
        case (4, 1): return .bent_4
        case (4, 0): return .tetrahedral
            
        case (5, 5): return .trigonalBipyramidal
        case (5, 4): return .seeSaw
        case (5, 3): return .tShape
        case (5, 2), (5, 1): return .linear
        case (5, 0): return .trigonalBipyramidal
            
        case (6, 6): return .octahedral
        case (6, 5): return .squarePyramidal
        case (6, 4): return .squarePlanar
        case (6, 3): return .tShape
        case (6, 2), (6, 1): return .linear
        case (6, 0): return .octahedral
            
        case (7, 7): return .pentagonalBipyramidal
        case (7, 6): return .distortedOctahedral
        case (7, 5): return .squarePyramidal
        case (7, 4): return .seeSaw
        case (7, 3): return .tShape
        case (7, 2), (7, 1): return .linear
        case (7, 0): return .pentagonalBipyramidal
            
        default:
            return nil
        }
    }

    func direction(at index: Int) -> SIMD3<Float> {
        switch self {
        case .linear:
            let directions: [SIMD3<Float>] = [
                [1, 0, 0],
                [-1, 0, 0]
            ]
            return directions[index % directions.count]

        case .trigonalPlanar:
            let angle120 = 2 * Float.pi / 3
            let directions: [SIMD3<Float>] = (0..<3).map {
                SIMD3<Float>(cos(angle120 * Float($0)), sin(angle120 * Float($0)), 0)
            }
            return directions[index % directions.count]

        case .tetrahedral:
            let directions: [SIMD3<Float>] = [
                [1, 1, 1],
                [-1, -1, 1],
                [-1, 1, -1],
                [1, -1, -1]
            ].map { normalize($0) }
            return directions[index % directions.count]

        case .trigonalPyramidal:
            let directions: [SIMD3<Float>] = [
                [1, 0, -1],
                [-1, 0, -1],
                [0, 1, 1]
            ].map { normalize($0) }
            return directions[index % directions.count]

        case .bent_3:
            let deg = 117.0 * .pi / 180
            let directions: [SIMD3<Float>] = [
                [cos(-Float(deg) / 2), sin(-Float(deg) / 2), 0],
                [cos(Float(deg) / 2), sin(Float(deg) / 2), 0]
            ]
            return directions[index % directions.count]

        case .bent_4:
            let deg = 104.5 * .pi / 180
            let directions: [SIMD3<Float>] = [
                [cos(-Float(deg) / 2), sin(-Float(deg) / 2), 0],
                [cos(Float(deg) / 2), sin(Float(deg) / 2), 0]
            ]
            return directions[index % directions.count]

        case .trigonalBipyramidal:
            let directions: [SIMD3<Float>] = [
                [1, 0, 0],
                [-0.5, sqrt(3)/2, 0],
                [-0.5, -sqrt(3)/2, 0],
                [0, 0, 1],
                [0, 0, -1]
            ]
            return directions[index % directions.count]

        case .seeSaw:
            let directions: [SIMD3<Float>] = [
                [1, 0, 0],
                [-0.5, sqrt(3)/2, 0],
                [0, 0, 1],
                [0, 0, -1]
            ]
            return directions[index % directions.count]

        case .tShape:
            let directions: [SIMD3<Float>] = [
                [1, 0, 0],
                [-1, 0, 0],
                [0, 1, 0]
            ]
            return directions[index % directions.count]

        case .octahedral:
            let directions: [SIMD3<Float>] = [
                [1, 0, 0],
                [-1, 0, 0],
                [0, 1, 0],
                [0, -1, 0],
                [0, 0, 1],
                [0, 0, -1]
            ]
            return directions[index % directions.count]

        case .squarePyramidal:
            let directions: [SIMD3<Float>] = [
                [1, 1, 0],
                [-1, 1, 0],
                [-1, -1, 0],
                [1, -1, 0],
                [0, 0, 1]
            ].map { normalize($0) }
            return directions[index % directions.count]

        case .squarePlanar:
            let directions: [SIMD3<Float>] = [
                [1, 1, 0],
                [-1, 1, 0],
                [-1, -1, 0],
                [1, -1, 0]
            ].map { normalize($0) }
            return directions[index % directions.count]

        case .pentagonalBipyramidal:
            let angle = 2 * Float.pi / 5
            let equator: [SIMD3<Float>] = (0..<5).map {
                SIMD3<Float>(cos(angle * Float($0)), sin(angle * Float($0)), 0)
            }
            let axial: [SIMD3<Float>] = [
                [0, 0, 1],
                [0, 0, -1]
            ]
            let directions = equator + axial
            return directions[index % directions.count]

        case .distortedOctahedral:
            let directions: [SIMD3<Float>] = [
                [1, 0.2, 0],
                [-1, -0.2, 0],
                [0.1, 1, 0],
                [-0.1, -1, 0],
                [0, 0, 1],
                [0, 0, -1]
            ].map { normalize($0) }
            return directions[index % directions.count]
        }
    }

}
