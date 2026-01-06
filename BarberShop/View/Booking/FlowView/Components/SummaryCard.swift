//
//  SummaryCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct SummaryCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            SummaryRow(
                icon: "calendar",
                title: "Date",
                value: formatDate(appointment.appointmentDate)
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
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ":")
        guard components.count >= 2 else { return timeString }
        return "\(components[0]):\(components[1])"
    }
}

#Preview {
    SummaryCard(
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
        )
    )
}
