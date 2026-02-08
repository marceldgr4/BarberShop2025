import SwiftUI

struct NavigationButtons: View {
    @ObservedObject var viewModel: BookingViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Back Button
            if viewModel.currentStep != .selectBranch {
                Button {
                    withAnimation {
                        viewModel.previosStep()
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandOrange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandOrange.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            // Continue/Review Button
            Button {
                if viewModel.currentStep == .confirmation {
                    // Crear la cita
                    Task {
                        await viewModel.createBooking()
                    }
                } else {
                    // Continuar al siguiente paso
                    withAnimation {
                        viewModel.nextStep()
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.currentStep == .confirmation ? "Confirm Booking" :
                         viewModel.currentStep == .selectDateTime ? "Review" : "Continue")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    viewModel.canProceedToNextStep ?
                        Color.brandGradient :
                        LinearGradient(
                            colors: [.gray, .gray],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )
                .cornerRadius(12)
                .shadow(
                    color: viewModel.canProceedToNextStep ?
                        Color.brandOrange.opacity(0.3) : .clear,
                    radius: 8,
                    y: 4
                )
            }
            .disabled(!viewModel.canProceedToNextStep) // ✅ FIXED: Ahora es correcto
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
}

#Preview {
    NavigationButtons(viewModel: BookingViewModel())
}
