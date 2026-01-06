//
//  PlaceholderBarberCardView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct PlaceholderBarberCardView: View {
    let isLoading: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Group {
                            if isLoading {
                                ProgressView()
                                    .tint(.brandOrange)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                
                Text(isLoading ? "Loading..." : "No barbers")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("--")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 140)
        }
    }

#Preview {
    PlaceholderBarberCardView(isLoading: false)
}
