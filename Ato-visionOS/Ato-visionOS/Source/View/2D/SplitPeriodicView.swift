//
//  SplitPeriodicView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - SplitPeriodicView

/// 주기율표(왼쪽)와 원소 상세정보(오른쪽)를 좌우로 나눈 메인 뷰
/// 사용자가 원소를 선택하면 오른쪽에 상세정보가 표시됨

struct SplitPeriodicView: View {
    
    // MARK: - State
    // 사용자가 선택한 원소
    @State private var selectedAtom: DetailAtomModel? = nil
    @State private var selectedMolecule: DetailMoleculeModel? = nil
    @State private var elementDetail: ElementDetail? = nil

    // MARK: - Body
    var body: some View {
        GeometryReader {geometry in
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
            
            HStack(spacing: 10) {
                // MARK: - 주기율표 뷰 (왼쪽)
                ZStack(alignment: .bottom) {
                    PeriodicTableView(
                        selectedAtom: $selectedAtom,
                        width: width * 0.71,
                        height: height
                    )
                    .frame(width: width * 0.71, height: height)
                    .padding(.trailing, width * 0.02)
                    .bg()
                    .clipShape(RoundedRectangle(cornerRadius: 55))
                    ToolbarView(width: width, height: height)
                        .offset(y: 30)
                }
                
                ElementDetailView(
                    elementDetail: $elementDetail,  // ← 바인딩 전달
                    width: width * 0.28,
                    height: height
                )
                // MARK: - 상세 정보 뷰 (오른쪽)
                .frame(width: width * 0.28, height: height)
                .bg()
                .clipShape(RoundedRectangle(cornerRadius: 55))
            }
            .onChange(of: selectedAtom) {
                if let atom = selectedAtom {
                    elementDetail = .atom(atom)
                    selectedMolecule = nil  // 분자 선택 초기화
                }
            }
            .onChange(of: selectedMolecule) {
                if let molecule = selectedMolecule {
                    elementDetail = .molecule(molecule)
                    selectedAtom = nil  // 원자 선택 초기화
                }
            }
        }
    }
}
