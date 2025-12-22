//
//  FavoriteBarbersView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct FavoriteBarbersView: View {
    let barbers: [BarberWithRating]
    
    var body: some View {
        List(barbers) { barber in
            NavigationLink(destination: BarberDetailView(barber: barber)) {
                BarberRow(barber: barber)
            }
        }
        .navigationTitle("Favorite Barbers")
        .navigationBarTitleDisplayMode(.inline)
    }
}


