//
//  ImmersiveView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import RealityFoundation

struct ImmersiveView: View {
    @Environment(\.openWindow) private var openWindow
    
    let tappableEntityNames: [String] = [
        "game_ready_free_chocolates",
        "Cube_002",
        "Cube_003",
        "Cube_004",
        "cc0_match_box",
        "free_low_poly_mining_assets",
        "Cylinder_002",
        "low_poly_stylized_game_items_poison"
    ]
    
    var body: some View {
        RealityView { content in
            // 임머시브 콘텐츠 엔티티 로드
            if let immersiveContentEntity = try? await Entity(named: "ImmersiveSpace", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                
                // 탭 가능한 각 Entity에 대해 컴포넌트 추가
                for entityName in tappableEntityNames {
                    if let entity = immersiveContentEntity.findEntity(named: entityName) {
                        
                        // MARK: - HoverEffectComponent 추가
                        // 이미 HoverEffectComponent가 없는 경우에만 추가합니다.
                        if !entity.components.has(HoverEffectComponent.self) {
                            entity.components.set(HoverEffectComponent())
                        }

                        // MARK: - InputTargetComponent 및 CollisionComponent 추가
                        // 탭 제스처 및 호버 효과를 위해 InputTargetComponent는 필수입니다.
                        if !entity.components.has(InputTargetComponent.self) {
                            entity.components.set(InputTargetComponent())
                        }
                        
                        if entity.components[CollisionComponent.self] == nil {
                            // 충돌 모양은 Entity의 형태에 맞게 조정해야 할 수 있습니다.
                            // 예: sphere.generateSphere, box.generateBox
                            // 여기서는 일반적인 캡슐 형태로 기본값을 둡니다. 필요시 변경하세요.
                            entity.components.set(CollisionComponent(shapes: [.generateCapsule(height: 0.1, radius: 0.05)]))
                        }
                        if entity.components[InputTargetComponent.self] == nil {
                            entity.components.set(InputTargetComponent())
                        }
                        print("Entity '\(entityName)' found and components added.")
                    } else {
                        print("Warning: Entity '\(entityName)' not found in 'ImmersiveSpace'.")
                    }
                }
            }
        }
        // RealityView에 탭 제스처 추가
        // .targetedToAnyEntity()는 RealityView 내의 모든 Entity에 대한 탭을 감지
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    let tappedEntity = value.entity
                    
                    // 탭된 Entity의 이름이 탭 가능한 목록에 있는지 확인
                    if tappableEntityNames.contains(tappedEntity.name) {
                        print("✅ Entity '\(tappedEntity.name)' tapped via SwiftUI Gesture!")
                        
                        openWindow(id: "myVolumeWindow")
//                        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.03), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
//                        sphere.position = [0, 0.3, 0]
//                        tappedEntity.addChild(sphere)
                    } else {
                        print("Tapped entity: \(tappedEntity.name) (Not a target entity)")
                    }
                }
        )

    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
