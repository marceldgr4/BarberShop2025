//
//  BranchSelectedCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct BranchSelectionCard: View {
    @ObservedObject var viewModel: BookingViewModel
    let branch: Branch
    let isSelected: Bool
    let onTap : () -> Void
    
    var body: some View {
        Button(action: onTap){
            VStack(alignment: .leading, spacing: 12){
                AsyncImage(url: URL(string: branch.imageUrl ?? "")){ image in image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.brandOrange.opacity(0.3))
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 40))
                                .foregroundColor(.brandOrange)
                        )
                }
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text(branch.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if isSelected{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                        }
                    }
                    HStack(spacing: 6){
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        Text(branch.address)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    HStack(spacing: 6){
                        Image(systemName: "phone.fill")
                            .foregroundColor(.brandOrange)
                            .font(.caption)
                        Text(branch.phone)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal,8)
            }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color.brandOrange.opacity(0.5): Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.brandOrange : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
        }
    }



#Preview {
    BranchSelectionCard(
        viewModel: BookingViewModel(),
        branch: Branch(
            id: UUID(),
            name: "Central Barbershop",
            address: "Calle 72 #45-67, Barranquilla",
            latitude: 10.9878,
            longitude: -74.7889,
            phone: "+57 300 123 4567",
            email: "central@barbershop.com",
            isActive: true,
            imageUrl: nil,
            createdAt: Date(),
            updatedAt: Date()
        ),
        isSelected: true,
        onTap: {}
    )
    .padding()
}

