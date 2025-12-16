//
//  BreanchMapMarker.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct BranchMapMarker: View {
    let branch: Branch
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap){
            VStack(spacing: 0){
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(y: -5)
            }
        }
    }
}

#Preview("Marker Simple") {
    BranchMapMarker(
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
        onTap: {
            print("Central Branch tapped")
        }
    )
    .padding(50)
    .background(Color.gray.opacity(0.2))
}
