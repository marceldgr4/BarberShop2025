//
//  PlaceholderServiceCardView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct PlaceholderServiceCardView: View {
    let isLoading: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 160, height: 160)
                .overlay(
                    Group{
                        if isLoading{
                            ProgressView()
                                .tint(.brandOrange)
                        }else{
                            Image(systemName: "scissors")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                    }
                    )
            VStack(alignment: .leading, spacing: 4){
                Text(isLoading ? "Loading...": "No services")
                    .font(.headline)
                    .foregroundColor(.gray)
                HStack{
                    Text("--")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("--")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal,4)
        }
        .frame(width: 160)
    }
}

#Preview {
    PlaceholderServiceCardView(isLoading: true)
}
