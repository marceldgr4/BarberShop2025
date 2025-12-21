//
//  PromotionsListView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/12/25.
//

import SwiftUI

struct PromotionsListView: View {
    let promotions: [Promotion]
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing: 15){
                ForEach(promotions) { promotion in
                    PromotionCard(promotion: promotion)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Special Offers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

