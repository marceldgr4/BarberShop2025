//
//  SuccessView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct SuccessView: View {
    let appointment: Appointment
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
            }
            
            // Success Message
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
            
            // Appointment Summary
            VStack(alignment: .leading, spacing: 14) {
                SummaryRow(
                    icon: "calendar",
                    title: "Date",
                    value: appointment.appointmentDate
                )
                
                SummaryRow(
                    icon: "clock",
                    title: "Time",
                    value: formatTime(appointment.appointmentTime)
                )
                
                Divider()
                
                SummaryRow(
                    icon: "dollarsign.circle",
                    title: "Total",
                    value: String(format: "$%.0f", appointment.totalPrice),
                    isHighlighted: true
                )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .padding(.horizontal)
            
            Spacer()
            
            // Done Button
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
        .background(Color(.systemBackground))
    }
    
    private func formatTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ":")
        guard components.count >= 2 else { return timeString }
        return "\(components[0]):\(components[1])"
    }
}

#Preview {
    SuccessView(
        appointment: Appointment(
            id: UUID(),
            userId: UUID(),
            branchId: UUID(),
            barberId: UUID(),
            serviceId: UUID(),
            statusId: UUID(),
            appointmentDate: "2025-01-15",
            appointmentTime: "10:00:00",
            totalPrice: 25000,
            notes: nil,
            createdAt: Date(),
            updatedAt: Date()
        ),
        onDismiss: {}
    )
}
