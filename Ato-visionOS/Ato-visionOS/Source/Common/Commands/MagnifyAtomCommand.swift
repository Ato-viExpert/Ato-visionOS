//
//  MagnifyAtomCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/28/25.
//

import SwiftUI
import RealityKit

/// 원자를 확대하거나 복원하는 명령 객체.
/// 확대된 원자는 시각적으로 강조된 형태로 표시되며,
/// 이전 확대 상태는 undo를 통해 복구 가능함.
final class MagnifyAtomCommand: Command {
    
    // MARK: - Properties
    
    private let previousAtom: LabAtom?
    private let newAtom: LabAtom?

    private var prevOriginalEntity: Entity?
    private var newOriginalEntity: Entity?

    private var prevPosition: SIMD3<Float>?
    private var prevOrientation: simd_quatf?

    // MARK: - Init
    
    /// MagnifyAtomCommand를 초기화합니다.
    /// - Parameters:
    ///   - previous: 이전에 확대되었던 원자 (복원할 대상)
    ///   - new: 새롭게 확대될 원자
    init(previous: LabAtom?, new: LabAtom?) {
        self.previousAtom = previous
        self.newAtom = new
    }

    // MARK: - Public Methods
    
    /// 명령을 실행합니다. 이전 확대 원자를 복원하고, 새 원자를 확대합니다.
    /// - Parameter content: RealityView에 포함된 콘텐츠
    /// - Returns: 생성된 확대 엔티티(CommandResult.entity) 또는 없음(.none)
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        if let prev = previousAtom {
            try await restoreOriginalAtom(prev, in: content)
        }
        
        if let new = newAtom {
            return try await magnifyAtom(new, in: content)
        }

        return .none
    }
    
    /// 명령을 되돌립니다. 새로 확대된 원자를 복원하고, 이전 원자를 다시 확대합니다.
    /// - Parameter content: RealityView에 포함된 콘텐츠
    /// - Returns: 복원된 확대 엔티티(CommandResult.entity) 또는 없음(.none)
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        if let new = newAtom {
            try await restoreOriginalAtom(new, in: content)
        }
        
        if let prev = previousAtom {
            return try await magnifyAtom(prev, in: content, usePreviousTransform: true)
        }

        return .none
    }

    // MARK: - Private Methods
    
    /// 확대된 엔티티를 제거하고 원래 엔티티를 복원합니다.
    /// - Parameters:
    ///   - atom: 복원할 원자
    ///   - content: RealityView에 포함된 콘텐츠
    private func restoreOriginalAtom(_ atom: LabAtom, in content: RealityViewContent) async throws {
        guard let magnified = atom.magnifiedEntity else { return }

        let position = await magnified.position
        let orientation = await magnified.orientation

        await magnified.removeFromParent()
        content.remove(magnified)

        let original = atom.entity
        if atom === previousAtom {
            prevOriginalEntity = original
            prevPosition = position
            prevOrientation = orientation
        } else {
            newOriginalEntity = original
        }

        if let original = original {
            await MainActor.run {
                original.position = position
                original.orientation = orientation
            }
            content.add(original)
        }
    }
    
    /// 원자 엔티티를 제거하고 확대된 엔티티로 교체합니다.
    /// - Parameters:
    ///   - atom: 확대할 원자
    ///   - content: RealityView에 포함된 콘텐츠
    ///   - usePreviousTransform: 복원 시 이전 위치/회전값을 사용할지 여부
    /// - Returns: 생성된 확대 엔티티(CommandResult.entity) 또는 없음(.none)
    private func magnifyAtom(_ atom: LabAtom, in content: RealityViewContent, usePreviousTransform: Bool = false) async throws -> CommandResult {
        guard let original = atom.entity else { return .none }

        let parent = await original.parent
        let position = await original.position
        let orientation = await original.orientation

        if atom === newAtom {
            newOriginalEntity = original
        }

        await original.removeFromParent()

        let magnified = await atom.loadMagnificationEntity()
        await MainActor.run {
            magnified.position = usePreviousTransform ? (prevPosition ?? .zero) : position
            magnified.orientation = usePreviousTransform ? (prevOrientation ?? simd_quatf()) : orientation
        }

        if usePreviousTransform {
            content.add(magnified)
        } else {
            await parent?.addChild(magnified)
        }

        return .entity(magnified)
    }
}
