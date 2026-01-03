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
                        value: appointment.appointmentDate
                    )
                    
                    SummaryRow(
                        icon: "clock",
                        title: "Time",
                        value: appointment.appointmentTime
                    )
                    
                    SummaryRow(
                        icon: "scissors",
                        title: "Service",
                        value: appointment.serviceName
                    )
                    
                    SummaryRow(
                        icon: "person",
                        title: "Barber",
                        value: appointment.barberName
                    )
                    
                    Divider()
                    
                    SummaryRow(
                        icon: "dollarsign.circle",
                        title: "Total",
                        value: String(format: "$%.2f", appointment.totalPrice),
                        isHighlighted: true
                    )
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(14)
                .padding(.horizontal)
            }
        }
    

#Preview {
    SummaryCard()
}
