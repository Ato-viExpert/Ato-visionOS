//
//  AtomDetailView.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/26/25.
//

import SwiftUI

struct AtomDetailView: View {
    
    // MARK: - Properties
    let atom: DetailAtomModel
    let width: CGFloat
    let height: CGFloat
    
    let size: CGFloat = 100
    
    // MARK: - Init
    /// - Parameters:
    ///   - element: 상세 정보를 표시할 원소
    init(
        atom: DetailAtomModel,
        width: CGFloat,
        height: CGFloat
    ){
        self.atom = atom
        self.width = width
        self.height = height
    }
    

    var body: some View {
        VStack(spacing: 30) {
            // MARK: - 원소 이름
            VStack(alignment: .leading, spacing: 30) {
                Text("\(atom.symbol)(\(atom.name))")
                    .font(Font.custom("SF Pro Display", size: width * 0.08)
                        .weight(.bold)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                Divider()
                    .background(.white.opacity(0.4))
                    .frame(width: width * 0.66)
            }
            .frame(height: height * 0.1)
            
            VStack(alignment: .center) {
                
                if let atomType = AtomType(rawValue: atom.symbol) {
                    Atom2D(atomType: atomType, size: width * 0.3)
                } else {
                    Text("지원되지 않는 원소")
                }
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(atom.description)
                    .font(Font.custom("SF Pro Display", size: width * 0.04))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: height * 0.3)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, height * 0.05)
        .padding(.horizontal, width * 0.12)
    }
}
