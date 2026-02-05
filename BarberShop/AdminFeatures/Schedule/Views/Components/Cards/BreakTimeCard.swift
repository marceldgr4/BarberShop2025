//
//  BreakTimeCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/01/26.
//

import SwiftUI

struct BreakTimeCard: View {

    let breakTime: BreakTime
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.brandAccent.opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: breakTime.breakType.icon)
                    .foregroundColor(.brandAccent)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(breakTime.breakType.displayName)
                    .font(.headline)

                Text("\(breakTime.startTime) - \(breakTime.endTime)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(daysString)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Duration Badge
            Text("\(breakTime.duration) min")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.brandAccent.opacity(0.1))
                .cornerRadius(8)

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

    private var daysString: String {
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return breakTime.dayOfWeek
            .sorted()
            .map { dayNames[$0] }
            .joined(separator: ", ")
    }
}
