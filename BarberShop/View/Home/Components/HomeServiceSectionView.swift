//
//  HomeServiceSectionView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct HomeServiceSectionView: View {
    let services: [Service]
    let isLoading: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            SectionHeader(title: "Our Services", icon: "scissors", showSeeAll: !services.isEmpty){
                ServicesListView(services: services)
                
            }
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing:15){
                    if !services.isEmpty{
                        ForEach(services.prefix(6)){ service in
                            NavigationLink(destination: ServiceDetailView(service: service)){
                                ServiceCard(service: service)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }else{
                        ForEach(0..<4){_ in PlaceholderServiceCardView(isLoading:isLoading)}
                        }
                    }
                        .padding(.horizontal)
                }
            }
        }
    }


#Preview {
    HomeServiceSectionView(services: [], isLoading: false)
}
