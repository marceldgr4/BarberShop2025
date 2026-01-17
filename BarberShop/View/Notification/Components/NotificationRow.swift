//
//  NotificationRow.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import SwiftUI


struct NotificationRow: View {
    let notificacion: Notification
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            HStack(spacing: 15){
                ZStack{
                    Circle()
                        .fill(Color(hex: notificacion.type.color).opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: notificacion.type.color)
                        .foregroundColor(Color(hex: notificacion.type.color))
                        .font(.title3)
                }
                VStack(alignment: .leading, spacing: 4){
                    HStack{
                        Text(notificacion.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if !notificacion.isRead{
                            Circle()
                                .fill(Color.brandOrange)
                                .frame(width: 8, height: 8)
                        }
                    }
                    Text(notificacion.message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Text(notificacion.timestamp.timeAgoDisplay())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical,4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NotificationRow(
        notificacion: Notification(
            id: UUID(),
            type: .promotion, title: "¡Nueva Promoción!",
            message: "Obtén un 20% de descuento en tu próximo corte de barba.",
            timestamp: Date(),
            isRead: false, // Or whatever your enum cases are
            actionURL: "barbershop://promo", // Can be an empty string "" or nil if optional
            metaData: ["discount": "20%"]    // Usually a Dictionary [String: String]
        ),
        onTap: {
            print("Notificación presionada")
        }
    )
    .padding()
}
