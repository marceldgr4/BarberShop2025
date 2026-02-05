//
//  BarberInfoHeader.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/01/26.
//

import SwiftUI

struct BarberInfoHeader: View {
    let barber: BarberWithRating

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: barber.photoUrl ?? "")) {
                image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle().fill(Color.brandPrimary.opacity(0.3))
                    .overlay(Image(systemName: "person.fill").foregroundColor(.brandAccent))
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(barber.name).font(.headline)
                if let rating = barber.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                        Text(String(format: "%.1f", rating)).font(.caption).fontWeight(.semibold)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}
