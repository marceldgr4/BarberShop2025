//
//  SummaryRow.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//
import SwiftUI

struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(isHighlighted ? .brandOrange : .gray)
                .frame(width: 22)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(isHighlighted ? .bold : .regular)
                .foregroundColor(.primary)
        }
    }
}




