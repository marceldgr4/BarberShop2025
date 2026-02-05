//
//  BlockedDayCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/01/26.
//

import SwiftUI

struct BlockedDayCard: View {
    let override: ScheduleOverride
       let onDelete: () -> Void
       
       var body: some View {
           HStack(spacing: 12) {
               // Icon
               ZStack {
                   Circle()
                       .fill(Color.brandAccent.opacity(0.1))
                       .frame(width: 44, height: 44)
                   
                   Image(systemName: override.reason.icon)
                       .foregroundColor(.brandOrange)
               }
               
               // Info
               VStack(alignment: .leading, spacing: 4) {
                   Text(override.displayReason)
                       .font(.headline)
                   
                   Text(formatDate(override.date))
                       .font(.caption)
                       .foregroundColor(.gray)
               }
               
               Spacer()
               
               // Delete Button
               Button(action: onDelete) {
                   Image(systemName: "trash")
                       .foregroundColor(.red)
                       .padding(8)
                       .background(Color.red.opacity(0.1))
                       .clipShape(Circle())
               }
           }
           .padding()
           .background(Color(.systemGray6))
           .cornerRadius(12)
           .padding(.horizontal)
       }
       
       private func formatDate(_ dateString: String) -> String {
           guard let date = dateString.toDate() else { return dateString }
           let formatter = DateFormatter()
           formatter.dateFormat = "EEEE, MMM d, yyyy"
           return formatter.string(from: date)
       }
   }

