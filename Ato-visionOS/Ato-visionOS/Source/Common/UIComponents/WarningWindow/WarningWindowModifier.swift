import SwiftUI

// MARK: - WarningWindowModifier
/// 경고창 수정자
struct WarningWindowModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                
                WarningWindow(isPresented: $isPresented)
                    .transition(.scale)
                    .animation(.easeInOut, value: isPresented)
                    .onAppear {
                        WarningSound.shared.playWarningSound()
                    }
            }
        }
    }
}

// MARK: - Extension
/// View 확장으로 편리하게 사용할 수 있는 메서드 추가
/// .warningWindow(isPresented: $showWarning)를 통해 경고창 표시
extension View {
    func warningWindow(isPresented: Binding<Bool>) -> some View {
        modifier(WarningWindowModifier(isPresented: isPresented))
    }
}