//
//  HomeHeaderView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI
import MapKit

struct HomeHeaderView: View {
    @ObservedObject var locationManager: LocationManager
    var onNotificationTap: ()-> Void
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text("Location")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 4){
                    Image(systemName: "mapping.circle.fill")
                        .foregroundColor(.brandOrange)
                        .imageScale(.small)
                    Text(locationManager.cityName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
            }
            Spacer()
            Button(action: onNotificationTap){
                ZStack(alignment: .topTrailing){
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8,height: 8)
                        .offset(x: -2, y: 2)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    HomeHeaderView(locationManager: LocationManager(), onNotificationTap: {})
}
