//
//  VolumeWindowContentView.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/28/25.
//

import SwiftUI
import RealityKit

struct VolumeWindowContentView: View {
    var body: some View {
        // 볼륨 윈도우에 표시할 내용
        // 간단한 Text나 3D 콘텐츠 (RealityView)를 넣을 수 있습니다.
        VStack {
            Text("안녕하세요! 볼륨 윈도우입니다.")
                .font(.extraLargeTitle)
                .padding()

            // 예시: 볼륨 윈도우 내부에 작은 3D 오브젝트 표시
            RealityView { content in
                let box = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .green, isMetallic: true)])
                content.add(box)
            }
            .frame(width: 0.4, height: 0.4) // 볼륨 윈도우 내 RealityView 크기
        }
    }
}

#Preview {
    VolumeWindowContentView()
}
