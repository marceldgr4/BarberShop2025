//
//  DayCell.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/01/26.
//

import SwiftUI

struct DayCell: View {
    
        let date: Date
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    Text(dayLetter)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white : .gray)
                    
                    Text("\(dayNumber)")
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.brandOrange : Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        private var dayLetter: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return String(formatter.string(from: date).prefix(1))
        }
        
        private var dayNumber: Int {
            Calendar.current.component(.day, from: date)
        }
    }

