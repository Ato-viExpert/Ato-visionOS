//
//  ElementDetailView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - ElementDetailView
struct ElementDetailView: View {
    @Environment(AppModel.self) private var appModel
    private var moleculeManager: MoleculeManager {
        appModel.moleculeManager
    }
    
    @Binding var elementDetail: ElementDetail?
    @State private var selectedMolecule: DetailMoleculeModel? = nil
    
    private let allDescriptions = DetailMoleculeMockData.allDescriptions
    let width: CGFloat
    let height: CGFloat
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 30) {
            
            Picker("분자 선택", selection: $selectedMolecule) {
                ForEach(DetailMoleculeMockData.allDescriptions, id: \.id) { molecule in
                    Text(molecule.name).tag(Optional(molecule))
                }
            }
            .onChange(of: selectedMolecule) {
                if let molecule = selectedMolecule {
                    elementDetail = .molecule(molecule)
                }
            }
            
            switch elementDetail {
            case .atom(let atom):
                AtomDetailView(atom: atom, width: width, height: height)
                
            case .molecule(let molecule):
                MoleculeDetailView(molecule: molecule, width: width, height: height)
            case .none:
                VStack {
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.1)
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text("원소 또는 분자를 선택해주세요.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .padding()
        .onChange(of: moleculeManager.selectedMolecule) { newValue in
            if let selected = newValue {
                if let matched = allDescriptions.first(where: { $0.symbol == selected.compositionSymbol.subscripted }) {
                    print("✅ 일치하는 분자: \(matched.name)")
                    selectedMolecule = matched
                    elementDetail = .molecule(matched)
                } else {
                    print("⚠️ 일치하는 분자가 없습니다.")
                }
            }
        }

    }
}

// TODO: - 이넘 파일로 이동 필요
enum ElementDetail {
    case atom(DetailAtomModel)
    case molecule(DetailMoleculeModel)
}
