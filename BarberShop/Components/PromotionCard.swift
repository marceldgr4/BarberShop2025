//
//  PromotionCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct PromotionCard: View {
    let promotion: Promotion
    var body: some View {
        ZStack(alignment: .bottomLeading ){
            AsyncImage(url: URL(string: promotion.imageUrl ?? "" )) {
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                Rectangle()
                    .fill(LinearGradient(colors: [.blue, .purple],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
            }
            .frame(width: 280,height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            LinearGradient(colors: [.clear, .black.opacity(0.8)],
                           startPoint: .top ,
                           endPoint: .bottom)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading, spacing: 4) {
                if let discount = promotion.discountPercentage, discount > 0 {
                    Text("-\(Int(discount))% DESCUENTO")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal,8)
                        .padding(.vertical,4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                Text(promotion.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
            .padding()
            
        }
        .frame(width: 280, height: 160)
    }
}

#Preview {
    PromotionCard(promotion: Promotion(id: UUID(),
                                       title: "Promo",
                                       description: "Agregar descripcion",
                                       discountPercentage: 30,
                                       startDate: "01/12/2025",
                                       endDate: "30/12/2025",
                                       isActive: true,
                                       imageUrl: nil,
                                       createdAt: Date()))
}
