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
                
                BookingProgressBar(currentStep: viewModel.currentStep)
                    .padding(.horizontal)
                    .padding(.top,10)
            }
        }
    }
}

#Preview {
    BookingFlowView()
}
