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
    @State private var viewModel: LabViewModel
    
    // MARK: - Init
    
    /// LabView
    /// - Parameter viewModel: LabViewModel
    init(viewModel: LabViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        RealityView { content in
            appModel.realityContent = content
        } update: { content in
            setupEntities(in: content)
        }
        .onChange(of: appModel.toolChangeRequest) { _, newValue in
            guard let newTool = newValue else { return }
            handleToolChange(to: newTool)
        }
        .gesture(appModel.selectedTool == .move ? dragGesture : nil)
        .gesture(tapGesture)
    }
    
    // MARK: - Entity Setup
    
    /// 초기 RealityViewContent 내의 모든 엔티티에 충돌 감지와 물리 속성을 설정합니다.
    /// - Parameter content: RealityKit 뷰의 콘텐츠 엔티티 컨테이너입니다.
    private func setupEntities(in content: RealityViewContent) {
        for entity in content.entities {
            if entity.components[CollisionComponent.self] == nil {
                let shape = ShapeResource.generateSphere(radius: 0.05)
                entity.components.set(CollisionComponent(shapes: [shape]))
            }
            let material = PhysicsMaterialResource.generate(staticFriction: 0.0, dynamicFriction: 0.0, restitution: 0.95)
            let physicsBody = PhysicsBodyComponent(massProperties: .init(mass: 0.005), material: material, mode: .kinematic)
            entity.components.set(physicsBody)
        }
    }
    
    // MARK: - Gestures
    
    /// Move 툴이 선택된 경우 엔티티를 드래그로 이동시킬 수 있는 제스처입니다.
    private var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if viewModel.initialPosition == nil {
                    viewModel.initialPosition = value.entity.position
                }
                let movement = value.convert(value.translation3D, from: .global, to: .scene)
                value.entity.position = (viewModel.initialPosition ?? .zero) + movement.grounded
            }
            .onEnded { _ in
                viewModel.initialPosition = nil
            }
    }
    
    /// RealityKit 엔티티를 탭하여 선택 동작을 수행하는 제스처입니다.
    /// 선택된 툴 타입에 따라 다른 동작이 실행됩니다.
    private var tapGesture: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                handleTap(on: value.entity)
            }
    }
}

// MARK: - Tap Handling Methods

extension LabView {
    /// 사용자가 RealityKit 엔티티를 탭했을 때 실행됩니다.
    /// 현재 선택된 툴 종류에 따라 확대/결합/삭제 등의 명령을 실행합니다.
    /// - Parameter entity: 유저가 탭한 RealityKit 엔티티입니다.
    private func handleTap(on entity: Entity) {
        guard let content = appModel.realityContent else { return }

        switch appModel.selectedTool {
        case .magnify:
            handleMagnifyTap(on: entity, in: content)
        case .bond, .dissociate:
            handleBondDissociateTap(on: entity, in: content)
        case .erase:
            handleEraseTap(on: entity, in: content)
        default:
            break
        }
    }
    
    /// 확대 툴 선택 상태에서 원자를 탭했을 때 처리합니다.
    /// 이미 확대된 원자면 확대 해제하고, 아니면 새로 확대합니다.
    /// - Parameters:
    ///   - entity: 유저가 탭한 RealityKit 엔티티입니다.
    ///   - content: RealityView에서 제공하는 콘텐츠 엔티티 컨테이너입니다.
    private func handleMagnifyTap(on entity: Entity, in content: RealityViewContent) {
        guard let tapped = appModel.atomManager.findAtom(by: entity.name) else { return }

        if tapped.atomId != viewModel.currentMagnifiedAtom?.atomId {
            let command = MagnifyAtomCommand(previous: viewModel.currentMagnifiedAtom, new: tapped)
            viewModel.currentMagnifiedAtom = tapped
            Task { await appModel.commandManager.execute(command, in: content) }
        } else {
            let command = MagnifyAtomCommand(previous: viewModel.currentMagnifiedAtom, new: nil)
            viewModel.deselectMagnifiedAtom()
            Task { await appModel.commandManager.execute(command, in: content) }
        }
    }
    
    
    /// 사용자가 원자를 탭했을 때 결합 또는 분해 도구에 따라 적절한 명령을 실행합니다.
    /// - Parameters:
    ///   - entity: 사용자 입력이 발생한 RealityKit 엔티티
    ///   - content: RealityView의 콘텐츠. entity 추가 및 제거에 사용됨
    private func handleBondDissociateTap(on entity: Entity, in content: RealityViewContent) {
        guard let labAtom = appModel.atomManager.findAtom(by: entity.name) else { return }
        
        guard !viewModel.selectedAtoms.contains(where: { $0.atomId == labAtom.atomId }) else { return }
        viewModel.selectedAtoms.append(labAtom)
        
        guard viewModel.selectedAtoms.count == 2 else { return }
        
        let atomA = viewModel.selectedAtoms[0]
        let atomB = viewModel.selectedAtoms[1]
        
        switch appModel.selectedTool {
        case .bond:
            let command = BondCommand(
                atomA: atomA,
                atomB: atomB,
                atomManager: appModel.atomManager,
                moleculeManager: appModel.moleculeManager
            )
            Task { await appModel.commandManager.execute(command, in: content) }
            
        case .dissociate:
            let command = DissociateCommand(atomA: atomA, atomB: atomB, moleculeManager: appModel.moleculeManager)
            Task { await appModel.commandManager.execute(command, in: content) }
            
        default:
            break
        }
        
        viewModel.resetSelection()
    }
    
    /// 삭제 툴 선택 상태에서 원자나 분자를 탭하면 해당 객체를 삭제합니다.
    /// - Parameters:
    ///   - entity: 유저가 탭한 RealityKit 엔티티입니다.
    ///   - content: RealityView에서 제공하는 콘텐츠 엔티티 컨테이너입니다.
    private func handleEraseTap(on entity: Entity, in content: RealityViewContent) {
        if let atom = appModel.atomManager.findAtom(by: entity.name) {
            let command = DeleteCommand(target: .atom(atom), atomManager: appModel.atomManager, moleculeManager: appModel.moleculeManager)
            Task { await appModel.commandManager.execute(command, in: content) }
        } else if let molecule = appModel.moleculeManager.allMoleculesList().first(where: { $0.entity?.name == entity.name }) {
            let command = DeleteCommand(target: .molecule(molecule), atomManager: appModel.atomManager, moleculeManager: appModel.moleculeManager)
            Task { await appModel.commandManager.execute(command, in: content) }
        }
    }

    // MARK: - Tool Change
    
    /// 툴 변경 요청이 발생했을 때 실행됩니다.
    /// 결합과 해제 툴일때는 분자 내 원자가 개별 선택되록 터치 영역을 바꿉니다.
    /// 현재 확대된 원자가 있다면 해제하고, 툴 상태를 갱신합니다.
    /// - Parameter newTool: 새로 선택된 툴 타입입니다.
    private func handleToolChange(to newTool: ToolType) {
        for molecule in appModel.moleculeManager.allMoleculesList() {
            molecule.setInteractionMode(for: newTool)
        }
        
        Task {
            if let magnified = viewModel.currentMagnifiedAtom {
                let cancelCommand = MagnifyAtomCommand(previous: magnified, new: nil)
                await appModel.commandManager.execute(cancelCommand, in: appModel.realityContent!)
                viewModel.deselectMagnifiedAtom()
            }

            let changeCommand = ChangeToolCommand(from: appModel.selectedTool, to: newTool, appModel: appModel)
            await appModel.commandManager.execute(changeCommand, in: appModel.realityContent!)
            appModel.selectedTool = newTool
            appModel.toolChangeRequest = nil
        }
    }
}

#Preview(windowStyle: .volumetric) {
    LabView(viewModel: LabViewModel())
        .environment(AppModel())
}
