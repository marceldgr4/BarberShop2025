//
//  PlaceholderPromotionCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct PlaceholderPromotionCard: View {
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
                .frame(width: 280, height: 160)
            
            VStack(spacing: 12) {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                if isLoading {
                    ProgressView()
                        .tint(.brandOrange)
                } else {
                    Text("No promotions")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    PlaceholderPromotionCard(isLoading: true)
}
