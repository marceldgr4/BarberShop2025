//
//  BookingFlowView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import SwiftUI

struct BookingFlowView: View {
    @StateObject private var viewModel = BookingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                
                ProgressBar(currentStep: viewModel.currentStep)
                    .padding(.horizontal)
                    .padding(.top,10)
                StepContent(viewModel: viewModel)
                Spacer()
                NavigationButtons(viewModel: viewModel)
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundColor(.brandOrange)
                }
            }
            .overlay{
                if viewModel.isLoading{
                    LoadingOverlay()
                }
            }
            .overlay{
                if viewModel.showSuccess, let appointment = viewModel.bookingConfirmation{
                    SuccessView(appointment: appointment){
                        dismiss()
                    }
                }
            }
            .alert("Error",isPresented: .constant(viewModel.errorMessage != nil)){
                Button("OK"){
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage{
                    Text(error)
                }
            }
        }
    }
}

#Preview {
    BookingFlowView()
}
