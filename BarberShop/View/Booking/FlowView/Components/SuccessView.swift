//
//  SuccessView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct SuccessView: View {
    let appointment: Appointment?
       let onDismiss: () -> Void
       
       var body: some View {
           VStack(spacing: 30) {
               Spacer()
               
               ZStack {
                   Circle()
                       .fill(Color.green.opacity(0.1))
                       .frame(width: 120, height: 120)
                   
                   Image(systemName: "checkmark.circle.fill")
                       .resizable()
                       .frame(width: 80, height: 80)
                       .foregroundColor(.green)
               }
               
               VStack(spacing: 10) {
                   Text("Booking Confirmed!")
                       .font(.title)
                       .fontWeight(.bold)
                   
                   Text("Your appointment has been successfully booked")
                       .font(.subheadline)
                       .foregroundColor(.gray)
                       .multilineTextAlignment(.center)
                       .padding(.horizontal)
               }
               
               if let appointment = appointment {
                   SummaryCard(appointment: appointment)
               }
               
               Spacer()
               
               Button(action: onDismiss) {
                   Text("Done")
                       .fontWeight(.bold)
                       .foregroundColor(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.brandGradient)
                       .cornerRadius(12)
               }
               .padding(.horizontal)
               .padding(.bottom, 30)
           }
       }
}

#Preview {
    SuccessView()
}
