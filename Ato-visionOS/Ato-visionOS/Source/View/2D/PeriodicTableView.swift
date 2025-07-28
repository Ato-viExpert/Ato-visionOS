//
//  PeriodicTableView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI
import RealityFoundation

// MARK: - PeriodicTableView

/// 주기율표
/// 원소들을 버튼으로 배치하고, 선택 시 상위 뷰에 바인딩된 selectedElement를 업데이트함

let detailAtomList = DetailAtomMockData.allDescriptions

let detailAtomDict: [String: DetailAtomModel] = Dictionary(
    uniqueKeysWithValues: DetailAtomMockData.allDescriptions.map { ($0.symbol, $0) }
)

let elementsGrid: [[DetailAtomModel?]] = symbolGrid.map { row in
    row.map { symbol in
        symbol.isEmpty ? nil : detailAtomDict[symbol]
    }
}



struct PeriodicTableView: View {
    
    // MARK: - Binding

    @Binding var selectedAtom: DetailAtomModel?
    
    // MARK: - Properties
    let elementsGrid: [[DetailAtomModel?]]
    let width: CGFloat
    let height: CGFloat
    
    @Environment(AppModel.self) private var appModel
    
    // MARK: - Init
    
    /// - Parameters:
    ///   - selectedElement: 상위에서 선택된 원소
    ///   - elementsGrid: 2차원 원소 배열(주기율표 데이터)
    init(
        selectedAtom: Binding<DetailAtomModel?>,
        elementsGrid: [[DetailAtomModel?]],
        width: CGFloat,
        height: CGFloat
    ) {
        self._selectedAtom = selectedAtom
        self.elementsGrid = elementsGrid
        self.width = width
        self.height = height
        
    }
    
    // MARK: - Body
    var body: some View {
            
        let buttonWidthSpacing: CGFloat = width * 0.02
//        let buttonHeightSpacing: CGFloat = height * 0.01
        
        VStack {
            Spacer(minLength: 50)
            ToggleImmersiveSpaceButton()
            // MARK: - 타이틀 및 설명
            
            Spacer(minLength: 20)
            TitleSection(width: width)
            
            // MARK: - 주기율표 버튼
//                PeriodicGridView
            VStack(spacing: buttonWidthSpacing) {
                ForEach(0..<elementsGrid.count, id: \.self) { row in
                    HStack(spacing: buttonWidthSpacing) {
                        ForEach(0..<elementsGrid[row].count, id: \.self) { col in
                            if let element = elementsGrid[row][col],
                               let atomType = atomType(from: element) {
                                CustomButton(atom: atomType, width: width, height: height) {
                                    selectedAtom = element
                                    spawnAtom(of: atomType)
                                }
                            } else {     //빈 문자열("") → nil
                                Color.clear
                                    .frame(width: width * 0.08, height: height * 0.1)
                            }
                        }
                    }
                }
            }
            Spacer(minLength: 70)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(width * 0.04)
    }
    
    
    // MARK: - Methods
    
    /// - Parameter element: 원소 정보
    /// - Returns: AtomType (예: .hydrogen, .oxygen) 또는 nil
    private func atomType(from element: DetailAtomModel?) -> AtomType? {
        guard let symbol = element?.symbol else { return nil }
        return AtomType(rawValue: symbol)
    }
    
    /// - Parameter type: 생성할 원자의 AtomType (예: .hydrogen, .carbon 등)
    private func spawnAtom(of type: AtomType) {
        guard let content = appModel.realityContent else { return }
        let command = SpawnAtomCommand(atomType: type, atomManager: appModel.atomManager)
        Task {
            let _ = await appModel.commandManager.execute(command, in: content)
        }
    }
    
    @ViewBuilder
    private func CustomButton(
        atom: AtomType,
        width: CGFloat,
        height: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(atom.symbol)
                .font(.system(size: width * 0.04, weight: .semibold))
                .foregroundStyle(.white.opacity(0.3))
                .frame(width: width * 0.08, height: height * 0.1)
                .background(
                    RoundedRectangle(cornerRadius: width * 0.02)
                        .fill(.white.opacity(0.3))
                )
        }
        .frame(width: width * 0.08, height: height * 0.1)
        .buttonStyle(.borderless)
    }
    
    
    @ViewBuilder
    private func TitleSection(
        width: CGFloat
    ) -> some View {
        Text("주기율표")
            .font(.system(size: width * 0.04, weight: .semibold))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.98))
            .frame(maxWidth: .infinity, alignment: .center)
            .dynamicTypeSize(.large ... .xxxLarge)
        Spacer(minLength: 15)
        Text("버튼을 클릭해 원자를 살펴보고, 도구를 이용해 분자를 만들어보세요")
            .font(.system(size: width * 0.02, weight: .semibold))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0.97, green: 0.98, blue: 0.98))
            .dynamicTypeSize(.large ... .xxxLarge)
        Spacer(minLength: 55)
    }
}

