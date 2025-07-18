//
//  BackgroundModifier.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import Foundation
import SwiftUI

/// BG
struct BG: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .fill(
                        LinearGradient(
                            colors: [.backWhite, .backGray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.6)
                        .shadow(.inner(color: .white.opacity(0.25), radius: 3.38, x: 0, y: 1.13))
                    )
                    .shadow(color: .black.opacity(0.18), radius: 12.02, x: 0, y: 0.5)
            )
    }
}

// MARK: - extension

extension View {
    func bg() -> some View {
        self.modifier(BG())
    }
}
