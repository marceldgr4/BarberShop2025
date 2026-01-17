//
//   WeekAvailabilityCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/01/26.
//

import SwiftUI

struct WeekAvailabilityCard: View {
    @ObservedObject var viewModel: ScheduleViewModel
        
        private var weekStats: (total: Int, available: Int, booked: Int, blocked: Int) {
            let allBlocks = viewModel.selectedWeek.flatMap { date in
                viewModel.timeBlocks.filter {
                    $0.date == date.toString()
                }
            }
            
            let total = allBlocks.count
            let available = allBlocks.filter { $0.blockType == .available }.count
            let booked = allBlocks.filter { $0.blockType == .booked }.count
            let blocked = allBlocks.filter { $0.blockType == .blocked || $0.blockType == .break }.count
            
            return (total, available, booked, blocked)
        }
        
        var body: some View {
            VStack(spacing: 15) {
                HStack {
                    Text("Week Overview")
                        .font(.headline)
                    Spacer()
                    Text("\(weekStats.available) slots available")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        // Available
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: geometry.size.width * CGFloat(weekStats.available) / CGFloat(max(weekStats.total, 1)))
                        
                        // Booked
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: geometry.size.width * CGFloat(weekStats.booked) / CGFloat(max(weekStats.total, 1)))
                        
                        // Blocked
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: geometry.size.width * CGFloat(weekStats.blocked) / CGFloat(max(weekStats.total, 1)))
                    }
                }
                .frame(height: 20)
                .cornerRadius(10)
                
                // Legend
                HStack(spacing: 20) {
                    LegendItem(color: .green, label: "Available", count: weekStats.available)
                    LegendItem(color: .red, label: "Booked", count: weekStats.booked)
                    LegendItem(color: .gray, label: "Blocked", count: weekStats.blocked)
                }
                .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
struct LegendItem: View {
    let color: Color
    let label: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
            Text("(\(count))")
                .foregroundColor(.gray)
        }
    }
}


#Preview {
    WeekAvailabilityCard(viewModel: ScheduleViewModel())
}
