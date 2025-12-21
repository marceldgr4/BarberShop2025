//
//  BarberDetailView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct BarberDetailView: View {
    let barber: BarberWithRating
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo
                    AsyncImage(url: URL(string: barber.photoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(barber.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let rating = barber.rating, let totalReviews = barber.totalReviews {
                            HStack(spacing: 8) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", rating))
                                    .fontWeight(.semibold)
                                Text("(\(totalReviews) reviews)")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        Button(action: {
                            // TODO: Navigate to booking
                        }) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                Text("Book Appointment")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandGradient)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    
    }
}

