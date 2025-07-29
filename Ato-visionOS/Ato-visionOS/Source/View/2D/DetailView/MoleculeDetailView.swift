//
//  MoleculeDetailView.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/26/25.
//

import SwiftUI

struct MoleculeDetailView: View {
    
    let molecule: DetailMoleculeModel
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 30) {
                Text("\(molecule.symbol)(\(molecule.name))")
                    .font(Font.custom("SF Pro Display", size: width * 0.08)
                        .weight(.bold)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                
                Divider()
                    .background(.white.opacity(0.4))
                    .frame(width: width * 0.66)
            }
            .frame(height: height * 0.1)
            
            VStack(alignment: .center) {
                Image("\(molecule.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.4, height: height * 0.2)
            }
            VStack(alignment: .leading) {
                Text(molecule.description)
                    .font(Font.custom("SF Pro Display", size: width * 0.04))
                    .foregroundStyle(.white)
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


#Preview {
    MoleculeDetailView(
        molecule: DetailMoleculeMockData.allDescriptions[17],
        width: 600,
        height: 800
    )
}
