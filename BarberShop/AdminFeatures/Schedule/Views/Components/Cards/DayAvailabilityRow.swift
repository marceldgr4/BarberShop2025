//
//  DayAvailabilityRow.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/01/26.
//

import SwiftUI
import AdminFeatures.Schedule.Utilities

struct DayAvailabilityRow: View {
    let date: Date
        @ObservedObject var viewModel: ScheduleViewModel
        
        private var dayBlocks: [TimeBlock] {
            viewModel.timeBlocks.filter { $0.date == date.toString() }
        }
        
        private var isBlocked: Bool {
            guard let barber = viewModel.selectedBarber else { return false }
            let dateStr = date.toString()
            return viewModel.scheduleOverrides.contains { override in
                override.barberId == barber.id &&
                override.date == dateStr &&
                !override.isAvailable
            }
        }
        
        private var availableCount: Int {
            dayBlocks.filter { $0.blockType == .available }.count
        }
        
        var body: some View {
            HStack(spacing: 12) {
                // Day Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(dayName)
                        .font(.headline)
                        .foregroundColor(isBlocked ? .gray : .primary)
                    
                    Text(dayNumber)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 80, alignment: .leading)
                
                Spacer()
                
                // Status
                if isBlocked {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("Day Blocked")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                } else if dayBlocks.isEmpty {
                    Text("No schedule")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(availableCount) slots")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        
        private var dayName: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        
        private var dayNumber: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }

#Preview {
    DayAvailabilityRow(date: Date(), viewModel: ScheduleViewModel())
}
