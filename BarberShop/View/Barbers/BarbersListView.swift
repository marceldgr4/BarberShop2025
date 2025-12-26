//
//  BarberListView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct BarbersListView: View {
    let barbers: [BarberWithRating]
    @State private var searchText = ""
    
    var body: some View {
        List(filteredBarbers) { barber in
            NavigationLink(destination: BarberDetailView(barber: barber)) {
                BarberRow(barber: barber)
            }
        }
        .navigationTitle("Our Barbers")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search barbers")
    }
    
    private var filteredBarbers: [BarberWithRating] {
        if searchText.isEmpty {
            return barbers
        }
        return barbers.filter { barber in
            barber.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    NavigationStack {
        BarbersListView(barbers: [
            BarberWithRating(
                id: UUID(),
                branchId: UUID(),
                specialtyId: UUID(),
                name: "Carlos Martínez",
                photoUrl: nil,
                isActive: true,
                rating: 4.8,
                totalReviews: 156
            )
        ])
    }
}
