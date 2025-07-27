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
        .onChange(of: appModel.selectedTool) { oldValue, newValue in
            toolDidChange(to: newValue)
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
                guard let content = appModel.realityContent else { return }
                
                let entity = value.entity
                
                switch appModel.selectedTool {
                case .bond:
                    if let atom = appModel.atomManager.findAtom(by: entity.name) {
                        if !selectedAtoms.contains(where: { $0.atomId == atom.atomId }) {
                            selectedAtoms.append(atom)
                        }
                        
                        if selectedAtoms.count == 2 {
                            let atomA = selectedAtoms[0]
                            let atomB = selectedAtoms[1]
                            
                            let command = BondCommand(
                                atomA: atomA,
                                atomB: atomB,
                                moleculeManager: appModel.moleculeManager
                            )
                            
                            Task {
                                await appModel.commandManager.execute(command, in: content)
                            }
                            
                            selectedAtoms.removeAll()
                        }
                    }
                case .erase:
                    if let atom = appModel.atomManager.findAtom(by: entity.name) {
                        let command = DeleteCommand(
                            target: .atom(atom),
                            atomManager: appModel.atomManager,
                            moleculeManager: appModel.moleculeManager
                        )
                        Task {
                            await appModel.commandManager.execute(command, in: content)
                        }
                    } else if let molecule = appModel.moleculeManager.allMolecules.first(where: { $0.entity?.name == entity.name }) {
                        let command = DeleteCommand(
                            target: .molecule(molecule),
                            atomManager: appModel.atomManager,
                            moleculeManager: appModel.moleculeManager
                        )
                        Task {
                            await appModel.commandManager.execute(command, in: content)
                        }
                    }
                default:
                    break
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
