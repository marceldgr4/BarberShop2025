//
//  BarberRow.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 16/12/25.
//

import SwiftUI

struct BarberRow: View {
    let barber: BarberWithRating
    var body: some View {
        HStack(spacing: 12){
            AsyncImage(url: URL(string: barber.photoUrl ?? "")) {
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            }placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4){
                Text(barber.name)
                    .font(.headline)
                if let rating = barber.rating, let totalReviews = barber.totalReviews{
                    HStack(spacing: 4){
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                        Text("(\(totalReviews) reviews)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
                .font(.headline)
        }
    }
}

#Preview {
    BarberRow(barber: BarberWithRating(id: UUID(),
                                       branchId: UUID(),
                                       specialtyId: UUID(),
                                       name: "juan ariza",
                                       photoUrl: nil,
                                       isActive: true,
                                       rating: 3.5,
                                       totalReviews: 90))
    .padding()
}
