//
//  BarberCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct BarberCard: View {
    let barber: BarberWithRating
    
    var body: some View {
        VStack( alignment: .leading, spacing: 8){
            AsyncImage(url: URL(string: barber.photoUrl ?? "")) {
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            
                    )
            }
            .frame(width: 100,height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(barber.name)
                .font(.headline)
                .lineLimit(1)
            if let rating = barber.rating, let totalReviews = barber.totalReviews{
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                    Text("(\(totalReviews))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 140)
    }
}

#Preview {
    BarberCard(barber: BarberWithRating(id: UUID(),
                                        branchId: UUID(),
                                        specialtyId: nil,
                                        name: "prueba 1",
                                        photoUrl: nil,
                                        isActive: true,
                                        rating: 4.8,
                                        totalReviews: 156))
}
