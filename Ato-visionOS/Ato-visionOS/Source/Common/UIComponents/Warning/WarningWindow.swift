import SwiftUI

struct WarningView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image("atomIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 52)
                .clipShape(Circle())
            
            Text("알림")
                .font(.title3)
                .bold()
            
            Text("이 원자 조합으로는 분자가 만들어지지 않아요. 다른 조합을 시도해보세요!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Divider()
                .background(.white.opacity(0.2))
            
            Button(action: {
                isPresented = false
            }) {
                Text("닫기")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    WarningView(isPresented: .constant(true))
}
