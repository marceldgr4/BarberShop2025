import SwiftUI

struct SocialLoginButton: View {
    let icon: String
    let text: String
    var isSystemIcon: Bool = true // Añadimos esto por si usas logos personalizados (.png/.pdf)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isSystemIcon {
                    Image(systemName: icon)
                        .font(.title3)
                } else {
                    Image(icon) // Para logos en Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(text)
                    .fontWeight(.medium)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14) // Un poco más de aire vertical para un look premium
            .background(Color(.systemGray6))
            .cornerRadius(12)
            // Efecto sutil de presión
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview Mejorado
#Preview {
    VStack(spacing: 20) {
        SocialLoginButton(icon: "applelogo", text: "Continue with Apple") {
            print("Apple Login")
        }
        
        SocialLoginButton(icon: "g.circle.fill", text: "Continue with Google") {
            print("Google Login")
        }
    }
    .padding()
}
