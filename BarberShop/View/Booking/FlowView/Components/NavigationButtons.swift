//
//  NavigationButtons.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import SwiftUI

struct NavigationButtons: View {
    @ObservedObject var viewModel : BookingViewModel
    var body: some View {
        HStack(spacing: 15){
            if viewModel.currentStep != .selectBranch{
                Button{
                    withAnimation{
                        viewModel.previousStep()
                    }
                } label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandOrange)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandOrange.opacity(0.3))
                    .cornerRadius(12)
                }
            }
            Button {
                withAnimation{
                    viewModel.nextStep()
                }
            }label: {
                HStack{
                    Text(viewModel.currentStep == .selectDateTime ? "review": "Continue")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canProceedToNextStep ? Color.brandOrange: LinearGradient(colors: [.gray, .gray], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(color: viewModel.canProceedToNextStep ? Color.brandOrange.opacity(0.3): .clear, radius: 8, y: 4)
                
            }
            .disabled(viewModel.canProceedToNextStep)
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color:.black.opacity(0.1), radius: 10,y:-5)
    }
}

#Preview {
    NavigationButtons()
}
