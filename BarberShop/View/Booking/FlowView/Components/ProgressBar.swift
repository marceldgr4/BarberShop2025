//
//  ProgresBar.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct ProgressBar: View {
    let currentStep: BookingStep
    var body: some View {
        VStack(spacing:8){
            HStack(spacing: 8 ){
                ForEach(BookingStep.allCases, id: \.self){ step in
                    Circle()
                        .fill(step.rawValue <= currentStep.rawValue ? Color.brandOrange: Color.gray.opacity(0.3))
                        .frame( width: step == currentStep ? 12:8,
                                height: step == currentStep ? 12:8)
                        .overlay(
                            Circle()
                                .stroke(Color.brandOrange,lineWidth: step == currentStep ? 2:0)
                        .frame(width: 16, height: 16)
                    )
                    if step != BookingStep.allCases.last{
                        Rectangle()
                            .fill(step.rawValue < currentStep.rawValue ? Color.brandOrange : Color.gray.opacity(0.3))
                            .frame(height: 2)
                    }
                }
            }
            Text(currentStep.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.brandOrange)
        }
        .padding(.vertical,10)
    }
}

#Preview {
    ProgressBar(currentStep: .selectBranch)
}
