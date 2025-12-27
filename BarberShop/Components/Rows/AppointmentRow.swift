//
//  AppointmentRow.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct AppointmentRow: View {
    let appointment: AppointmentDetail
    
    var body: some View {
        HStack(spacing: 12) {
            // Barber Photo
            AsyncImage(url: URL(string: appointment.barberPhoto ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {  
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.brandOrange)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.serviceName)
                    .font(.headline)
                
                Text(appointment.barberName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(formatDate(appointment.appointmentDate))
                        .font(.caption)
                    
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(formatTime(appointment.appointmentTime))
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Status Badge
            Text(appointment.statusName.capitalized)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor(appointment.statusName))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
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
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "confirmed": return .blue
        case "in_progress": return .purple
        case "completed": return .green
        case "cancelled": return .red
        default: return .gray
        }
    }
}

#Preview("Lista Completa") {
    List {
        AppointmentRow(appointment: AppointmentDetail(
            id: UUID(),
            appointmentDate: "2025-12-12",
            appointmentTime: "14:30:00",
            totalPrice: 25000,
            notes: nil,
            statusName: "confirmed",
            barberName: "Carlos Martínez",
            barberPhoto: "nil",
            serviceName: "Corte + Barba",
            branchName: "Central",
            branchAddress: "Calle 72"
        ))
        
        AppointmentRow(appointment: AppointmentDetail(
            id: UUID(),
            appointmentDate: "2025-12-15",
            appointmentTime: "10:00:00",
            totalPrice: 18000,
            notes: nil,
            statusName: "pending",
            barberName: "Luis Rodríguez",
            barberPhoto: "nil",
            serviceName: "Corte",
            branchName: "Norte",
            branchAddress: "Calle 84"
        ))
        
        AppointmentRow(appointment: AppointmentDetail(
            id: UUID(),
            appointmentDate: "2025-12-08",
            appointmentTime: "16:00:00",
            totalPrice: 30000,
            notes: nil,
            statusName: "completed",
            barberName: "Pedro Gómez",
            barberPhoto: "nil",
            serviceName: "Premium",
            branchName: "Sur",
            branchAddress: "Calle 45"
        ))
    }
}
