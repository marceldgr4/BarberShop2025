//
//  StepContent.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import SwiftUI

struct StepContent: View {
    @ObservedObject var viewModel : BookingViewModel
    var body: some View {
        switch viewModel.currentStep {
        case .selectBranch:
            SelectBranchView(viewModel:viewModel)
        case .selectBarber:
            SelectBarberView( viewModel: viewModel)
        case .selectService:
            SelectServiceView( viewModel: viewModel)
        case .selectDateTime:
            SelectDateTimeView(viewModel: viewModel)
        case .confirmation:
            BookingConfirmationView(viewModel: viewModel)
        }
    }
}

#Preview {
    StepContent(viewModel: BookingViewModel())
}
