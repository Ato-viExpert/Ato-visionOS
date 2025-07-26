import SwiftUI

// MARK: - WarningWindow
/// 경고창 뷰
struct WarningWindow: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Text("결합할 수 없는 원자입니다.")
                .font(.headline)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
        }
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

