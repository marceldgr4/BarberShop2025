//
//  FilterChip.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
import SwiftUI

struct FilterChip: View{
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View{
        Button(action: action){
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white: .primary)
                .padding(.horizontal, 16)
                .padding(.vertical,8)
                .background(isSelected ? Color.brandOrange: Color(.systemGray6))
                .cornerRadius(20)
        }
        
    }
}

#Preview {
    FilterChip(title: "filter", isSelected: true, action: {})
}
