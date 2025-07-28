//
//  ChangeToolCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/28/25.
//

import SwiftUI
import RealityKit

/// 사용자의 툴 변경을 처리하는 명령 객체입니다.
/// 이전 툴에서 새 툴로의 변경을 수행하고, 실행 취소 시 이전 툴로 되돌립니다.
final class ChangeToolCommand: Command {
    
    // MARK: - Properties
    
    private let previousTool: ToolType
    private let newTool: ToolType
    private let appModel: AppModel
    
    // MARK: - Init
    
    /// 툴 변경 명령을 초기화합니다.
    /// - Parameters:
    ///   - old: 이전 툴 타입
    ///   - new: 새 툴 타입
    ///   - appModel: 상태 관리를 위한 앱 모델
    init(from old: ToolType, to new: ToolType, appModel: AppModel) {
        self.previousTool = old
        self.newTool = new
        self.appModel = appModel
    }
    
    // MARK: - Methods
    
    /// 툴 변경을 실행합니다.
    /// - Parameter content: RealityView의 콘텐츠 (사용되지 않음)
    /// - Returns: 명령 실행 결과
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        await MainActor.run {
            appModel.selectedTool = newTool
        }
        return .none
    }
    
    /// 툴 변경을 실행 취소합니다.
    /// - Parameter content: RealityView의 콘텐츠 (사용되지 않음)
    /// - Returns: 명령 실행 결과
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        await MainActor.run {
            appModel.selectedTool = previousTool
        }
        return .none
    }
}
