//
//  WeekNavigator.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/01/26.
//

import SwiftUI

import SwiftUI

// MARK: - Week Navigator
struct WeekNavigator: View {
    let selectedWeek: [Date]
    @Binding var selectedDate: Date
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.brandOrange)
                }
                
                Spacer()
                
                Text(weekRangeText)
                    .font(.headline)
                
                Spacer()
                
                Button(action: onNext) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.brandOrange)
                }
            }
            
            HStack(spacing: 8) {
                ForEach(selectedWeek, id: \.self) { date in
                    DayCell(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
    }
    
    private var weekRangeText: String {
        guard let first = selectedWeek.first,
              let last = selectedWeek.last else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }
}

