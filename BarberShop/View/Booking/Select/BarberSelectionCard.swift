//
//  BarberSelectedCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 1/01/26.
//

import SwiftUI

struct BarberSelectionCard: View {
    let barber: BarberWithRating
    let isSelected:Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            HStack(spacing:15){
                AsyncImage(url: URL(string: barber.photoUrl ?? "")){
                    image in image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.brandOrange.opacity(0.3))
                        .overlay(Image(systemName: "person.fill")
                            .foregroundColor(.brandOrange))
                }
                .frame(width: 70,height: 70)
                .clipShape(Circle())
                
                VStack(alignment:.leading, spacing: 8){
                    Text(barber.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if let rating = barber.rating, let totalReviews = barber.totalReviews{
                        HStack(spacing: 4){
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(String(format: "%,1f", rating))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("(\(totalReviews) reviews)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                    Spacer()
                    Image(systemName: isSelected ? "checkmark.circle.fill": "circle")
                        .foregroundColor(isSelected ? .green: .gray)
                        .font(.title2)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.green.opacity(0.05): Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1),radius: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    #Preview {
        VStack {
            BarberSelectionCard(
                barber: BarberWithRating(
                    id: UUID(),
                    branchId: UUID(),
                    specialtyId: UUID(),
                    name: "Carlos Martínez",
                    photoUrl: nil,
                    isActive: true,
                    rating: 4.8,
                    totalReviews: 156
                ),
                isSelected: true,
                onTap: {}
            )
            .padding()
            
            BarberSelectionCard(
                barber: BarberWithRating(
                    id: UUID(),
                    branchId: UUID(),
                    specialtyId: UUID(),
                    name: "Luis Rodríguez",
                    photoUrl: nil,
                    isActive: true,
                    rating: 4.6,
                    totalReviews: 98
                ),
                isSelected: false,
                onTap: {}
            )
            .padding()
        }
    }
