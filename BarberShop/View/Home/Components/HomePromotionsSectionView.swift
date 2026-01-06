//
//  HomePromotionsSectionView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct HomePromotionsSectionView: View {
    let promotions: [Promotion]
    let isLoading: Bool
    @State private var currentIndex = 0
    var body: some View {
        VStack(alignment:.leading, spacing: 12){
            SectionHeader(title: "Specila offers", icon: "tag.fill",showSeeAll: !promotions.isEmpty){
                PromotionsListView(promotions: promotions)
                
            }
            if !promotions.isEmpty{
                TabView(selection:$currentIndex){
                    ForEach(Array(promotions.enumerated()),id:\.element.id) { index, promotion in PromotionCard(promotion: promotion)
                            .padding(.horizontal,8)
                            .tag(index)
                    }
                }
                .frame(height: 180)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8){
                    ForEach(0..<promotions.count, id: \.self){
                        index in Circle()
                            .fill(currentIndex == index ? Color.brandOrange: Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentIndex == index ? 1.2: 1.0)
                            .animation(.spring(response:0.3), value: currentIndex)
                    }
                }
                .frame(maxWidth: .infinity)
            }else{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:15){
                        ForEach(0..<3 ){_ in PlaceholderPromotionCard(isLoading : isLoading) }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


#Preview {
    HomePromotionsSectionView(promotions:[], isLoading: true)
}
