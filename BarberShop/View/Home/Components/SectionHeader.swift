//
//  SectionHeader.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct SectionHeader<Destination:View>: View {
    let title: String
    let icon: String
    let showSeeAll: Bool
    let destination: () -> Destination
   
    var body: some View {
        HStack{
            Image(systemName: icon)
                .foregroundColor(.brandOrange)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            if showSeeAll{
                NavigationLink(destination: destination()){
                    HStack(spacing: 4){
                        Text("See All")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.brandOrange)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        SectionHeader(
            title: "Popular Services",
            icon: "scissors",
            showSeeAll: true
        ) {
            Text("See All Screen")
        }
    }
}

