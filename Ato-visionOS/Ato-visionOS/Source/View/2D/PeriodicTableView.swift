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


struct PeriodicTableView: View {
    
    // MARK: - Binding
    
    @Binding var selectedAtom: DetailAtomModel?
    
    // MARK: - Properties
//    let elementsGrid: [[DetailAtomModel?]]
    let width: CGFloat
    let height: CGFloat
    
    //    @Environment(AppModel.self) private var appModel
    
    // MARK: - Init
    
    /// - Parameters:
    ///   - selectedElement: 상위에서 선택된 원소
    ///   - elementsGrid: 2차원 원소 배열(주기율표 데이터)
    init(
        selectedAtom: Binding<DetailAtomModel?>,
//        elementsGrid: [[DetailAtomModel?]],
        width: CGFloat,
        height: CGFloat
    ) {
        self._selectedAtom = selectedAtom
//        self.elementsGrid = elementsGrid
        self.width = width
        self.height = height
        
    }
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            Spacer(minLength: 50)
            HStack {
                Spacer(minLength: 200)
                Text("가상 환경")
                    .font(.system(size: width * 0.02, weight: .semibold))
                ToggleImmersiveSpaceButton()
            }
            // MARK: - 타이틀 및 설명
            Spacer(minLength: 20)
            TitleSection(width: width)
            ElementsGridView(width: width, height: height, selectedAtom: $selectedAtom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(width * 0.04)
    }
    
}
    // MARK: - Methods

    
/// 상단 텍스트 뷰
fileprivate struct TitleSection : View {
    let width: CGFloat

    var body: some View {
        VStack(spacing: 15) {
            Text("주기율표")
                .font(.system(size: width * 0.04, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.97, green: 0.98, blue: 0.98))
                .frame(maxWidth: .infinity, alignment: .center)
                .dynamicTypeSize(.large ... .xxxLarge)
            
            Spacer(minLength: 15)
            Text("버튼을 클릭해 원자를 살펴보고, 도구를 이용해 분자를 만들어보세요")
                .font(.system(size: width * 0.02, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.97, green: 0.98, blue: 0.98))
                .dynamicTypeSize(.large ... .xxxLarge)
            Spacer(minLength: 55)
        }
    }
}


// MARK: - 주기율표 버튼
fileprivate struct ElementsGridView : View {
    @Environment(AppModel.self) private var appModel
    
    private let elementsGrid: [[String]] = ElementsGridView.generateGrid()
    
    private let width: CGFloat
    private let height: CGFloat
    @Binding var selectedAtom: DetailAtomModel?
    
    init(width: CGFloat, height: CGFloat, selectedAtom: Binding<DetailAtomModel?>) {
        self.width = width
        self.height = height
        self._selectedAtom = selectedAtom
    }
    
    private var buttonSpacing: CGFloat {
        width * 0.02
    }
    
    var body: some View {
//        VStack(spacing: buttonSpacing) {
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
            ForEach(0..<elementsGrid.count, id: \.self) { row in
//                HStack(spacing: buttonSpacing) {
                GridRow {
                    
//                    ForEach(0..<elementsGrid[row].count, id: \.self) { col in
//                        let symbol = elementsGrid[row][col]
//                        makeElementCell(symbol: symbol)
//                    }
                    ForEach(0..<elementsGrid[row].count, id: \.self) { col in
                        ElementGridCell(
                            symbol: elementsGrid[row][col],
                            width: width,
                            height: height,
                            spawnAtom: spawnAtom // 함수를 클로저로 전달
                        )
                    }
//                    ForEach(0..<elementsGrid[row].count, id: \.self) { col in
////                        let element = elementsGrid[row][col]
////                        let atomType = AtomType(from: element)
//                        let symbol = elementsGrid[row][col]
//                        let atomType = AtomType.from(symbol: symbol)
//                        
//                        if let atomType {
//                            CustomButton(text: atomType.symbol, width: width, height: height) {
////                                selectedAtom = element
//                                spawnAtom(of: atomType)
//                            }
//                            .frame(width: width * 0.08, height: height * 0.1)
//                        } else {     //빈 문자열("") → nil
//                            Color.clear
//                                .frame(width: width * 0.08, height: height * 0.1)
//                        }
//                    }
                }
            }
        }
        Spacer(minLength: 70)
    }
    
//    @ViewBuilder
//    private func makeElementCell(symbol: String) -> some View {
//        let buttonWidth = width * 0.08
//        let buttonHeight = height * 0.1
//
//        if let atomType = AtomType(from: symbol) {
//            CustomButton(atom: atomType, width: width, height: height) {
//                selectedAtom = DetailAtomMockData.find(bySymbol: symbol)
//                spawnAtom(of: atomType)
//            }
//            .frame(width: buttonWidth, height: buttonHeight)
//        } else {
//            Color.clear
//                .frame(width: buttonWidth, height: buttonHeight)
//        }
//    }
    
//    @ViewBuilder
//    private func CustomButton(
////        atom: AtomType,
//        text: String,
//        width: CGFloat,
//        height: CGFloat,
//        action: @escaping () -> Void
//    ) -> some View {
//        Button(action: action) {
//            Text(text)
//                .font(.system(size: width * 0.04, weight: .semibold))
//                .foregroundStyle(.white.opacity(0.3))
//                .frame(width: width * 0.08, height: height * 0.1)
//                .background(
//                    RoundedRectangle(cornerRadius: width * 0.02)
//                        .fill(.white.opacity(0.3))
//                )
//        }
//        .frame(width: width * 0.08, height: height * 0.1)
//        .buttonStyle(.borderless)
//    }
    
    // MARK: - Methods
    
    private static func generateGrid() -> [[String]] {
        let atoms = AtomListMockData.allAtoms()
        let maxPeriod = 5
        let validGroups: [Int] = [1, 2, 13, 14, 15, 16, 17, 18]
        
        var grid = Array(
            repeating: Array(repeating: "", count: validGroups.count),
            count: maxPeriod
        )
        
        for atom in atoms {
            let period = atom.period
            let group = atom.group
            guard (1...maxPeriod).contains(period),
                  let col = validGroups.firstIndex(of: group)
            else { continue }
            grid[period - 1][col] = atom.symbol
        }
        
        return grid
    }
    
    /// - Parameter type: 생성할 원자의 AtomType (예: .hydrogen, .carbon 등)
    private func spawnAtom(of type: AtomType) {
        guard let content = appModel.realityContent else { return }
        let command = SpawnAtomCommand(atomType: type, atomManager: appModel.atomManager)
        Task {
            let _ = await appModel.commandManager.execute(command, in: content)
        }
    }
}


//let detailAtomList = DetailAtomMockData.allDescriptions
//
//let detailAtomDict: [String: DetailAtomModel] = Dictionary(
//    uniqueKeysWithValues: DetailAtomMockData.allDescriptions.map { ($0.symbol, $0) }
//)
//
//let elementsGrid: [[DetailAtomModel?]] = symbolGrid.map { row in
//    row.map { symbol in
//        symbol.isEmpty ? nil : detailAtomDict[symbol]
//    }
//}

// MARK: - 추출된 셀 뷰
fileprivate struct ElementGridCell: View {
    let symbol: String
    let width: CGFloat
    let height: CGFloat
    let spawnAtom: (AtomType) -> Void // spawnAtom 함수를 전달하기 위한 클로저
    
    var body: some View {
        let buttonWidth = width * 0.08
        let buttonHeight = height * 0.1
        
        if let atomType = AtomType.from(symbol: symbol) {
            CustomButton(text: atomType.symbol, width: width, height: height) {
                spawnAtom(atomType)
            }
            .frame(width: buttonWidth, height: buttonHeight)
        } else {
            Color.clear
                .frame(width: buttonWidth, height: buttonHeight)
        }
    }
    
    @ViewBuilder
    private func CustomButton(
        text: String,
        width: CGFloat,
        height: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(text)
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
}
