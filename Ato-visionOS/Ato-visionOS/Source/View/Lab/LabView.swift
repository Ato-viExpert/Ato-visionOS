//
//  LabView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/26/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LabView: View {
    
    // MARK: - Properties
    
    @Environment(AppModel.self) private var appModel
    @State private var selectedAtoms: [LabAtom] = []    // ✅ LabView 내부에서만 사용
        @State private var initialPosition: SIMD3<Float>? = nil

    
    // MARK: - Body
    
    var body: some View {
        RealityView { content in
            appModel.realityContent = content
        } update: { content in
            for entity in content.entities {
                    // 1. 충돌 감지를 위한 CollisionComponent 추가 (없을 때만)
                    if entity.components[CollisionComponent.self] == nil {
                        let shape = ShapeResource.generateSphere(radius: 0.05)
                        let collision = CollisionComponent(shapes: [shape])
                        entity.components.set(collision)
                    }

                    // 2. 반발력 있는 PhysicsMaterial 설정
                    let material = PhysicsMaterialResource.generate(
                        staticFriction: 0.0,
                        dynamicFriction: 0.0,
                        restitution: 0.95 // 거의 완전 탄성 충돌
                    )

                    // 3. 중력은 무시하고 충돌만 적용되는 kinematic 설정
                    let physicsBody = PhysicsBodyComponent(
                        massProperties: .init(mass: 0.005),
                        material: material,
                        mode: .kinematic  // 중력 무시 + 충돌 반응 가능
                    )

                    entity.components.set(physicsBody)
                }
        }
        .onChange(of: appModel.selectedTool) { newTool in
            toolDidChange(to: newTool)
        }
        .gesture(appModel.selectedTool == .move ? dragGesture : nil)
        .gesture(tapGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if initialPosition == nil {
                    initialPosition = entity.position
                }
                let movement = value.convert(value.translation3D, from: .global, to: .scene)
                entity.position = (initialPosition ?? .zero) + movement.grounded
            }
            .onEnded { _ in
                initialPosition = nil
            }
    }
    
    var tapGesture: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                print("✅ TapGesture triggered")

                guard let content = appModel.realityContent else {
                    print("❌ realityContent 없음")
                    return
                }

                let entity = value.entity
                print("🔍 tapped entity name: \(entity.name)")

                // entity 이름으로 atom 찾기
                guard let atom = appModel.atomManager.findAtom(by: entity.name) else {
                    print("❌ atom 못 찾음: \(entity.name)")
                    return
                }

                print("✅ atom 찾음: \(atom.atomId)")

                if !selectedAtoms.contains(where: { $0.atomId == atom.atomId }) {
                    selectedAtoms.append(atom)
                    print("✅ atom 선택됨: 현재 선택된 개수 = \(selectedAtoms.count)")
                }

                if selectedAtoms.count == 2 {
                    let atomA = selectedAtoms[0]
                    let atomB = selectedAtoms[1]

                    print("📦 두 개 선택됨: \(atomA.atomId), \(atomB.atomId)")

                    let bondOrder = appModel.moleculeManager.predictBondOrder(atomA: atomA, atomB: atomB)
                    print("📐 예측된 결합 차수: \(bondOrder)")

                    let command = BondCommand(
                        atomA: atomA,
                        atomB: atomB,
                        bondOrder: bondOrder,
                        moleculeManager: appModel.moleculeManager
                    )

                    Task {
                        print("⚙️ BondCommand 실행 시작")
                        await appModel.commandManager.execute(command, in: content)
                        print("⚙️ BondCommand 실행 완료")
                    }

                    selectedAtoms.removeAll()
                    print("🧹 선택 초기화")
                }
            }
    }
    func toolDidChange(to newTool: ToolType) {
        for molecule in appModel.moleculeManager.allMolecules {
            molecule.setInteractionMode(for: newTool)
        }
    }


}

#Preview(windowStyle: .volumetric) {
    LabView()
        .environment(AppModel())
}
