//
//  HomeBarberSectionView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct HomeBarberSectionView: View {
    let barbers: [BarberWithRating]
    let isLoading: Bool
    var body: some View {
        VStack(alignment:.leading, spacing: 12){
            SectionHeader(title: "Top Rating", icon: "star.fill", showSeeAll: !barbers.isEmpty){
                BarbersListView(barbers: barbers )
            }
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing:15){
                    if !barbers.isEmpty{
                        ForEach(barbers.prefix(6)){
                            barber in NavigationLink(destination: BarberDetailView(barber: barber)){
                                BarberCard(barber: barber)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }else{
                        ForEach(0..<4){_ in PlaceholderBarberCardView(isLoading: isLoading)}
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeBarberSectionView(barbers: [], isLoading: false)
}
