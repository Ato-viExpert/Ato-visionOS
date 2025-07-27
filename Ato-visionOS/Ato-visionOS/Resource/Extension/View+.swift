import SwiftUI

// MARK: - Extension
/// View 확장으로 편리하게 사용할 수 있는 메서드 추가
/// .warningWindow(isPresented: $showWarning)를 통해 경고창 표시
extension View {
    func warningWindow(isPresented: Binding<Bool>) -> some View {
        modifier(WarningViewModifier(isPresented: isPresented))
    }
}
