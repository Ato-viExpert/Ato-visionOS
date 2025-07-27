import SwiftUI

// MARK: - WarningViewModifier
/// 경고창 수정자
struct WarningViewModifier: ViewModifier {
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
                
                WarningView(isPresented: $isPresented)
                    .transition(.scale)
                    .animation(.easeInOut, value: isPresented)
                    .task {
                        WarningSound.shared.playWarningSound()
                    }
            }
        }
    }
}
