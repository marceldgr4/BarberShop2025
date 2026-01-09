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
    let unreadCount: Int
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
                    
                    if unreadCount > 0{
                        ZStack{
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8,height: 8)
                            Text("\(min(unreadCount,99))")
                                .font(.system(size: 10,weight: .bold))
                                .foregroundColor(.white)
                        }
                                .offset(x: -3, y: 3)
                                .scaleEffect(unreadCount > 0 ? 1.8 : 1.1)
                                .animation(Animation.spring(response: 0.3,dampingFraction: 0.6)
                                    .repeatCount(3, autoreverses: true),
                                           value: unreadCount)
                        }
                    }
                }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    HomeHeaderView(
        locationManager: LocationManager(),
        unreadCount: 1,
        onNotificationTap: {})
    .padding()
}
