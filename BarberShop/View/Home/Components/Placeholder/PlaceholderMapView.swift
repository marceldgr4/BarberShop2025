//
//  PlaceholderMapView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct PlaceholderMapView: View {
    let isLoading: Bool
    let onRefresh:() ->Void
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill()
                .frame(height: 200)
            
            VStack(spacing:12){
                Image(systemName: "map")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                if isLoading{
                    ProgressView()
                        .tint(.brandOrange)
                    Text("Loading location...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }else{
                    Text("No location available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button("Refresh", action: onRefresh)
                        .font(.caption)
                        .foregroundColor(.brandOrange)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PlaceholderMapView(isLoading: true, onRefresh: {})
}
