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
                
                Image(systemName: "arrowtriangle.donw.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(y: -5)
            }
        }
    }
}

#Preview {
    BranchMapMarker(branch: Branch(id: UUID(),
                                    name: "name",
                                    address: "calle",
                                    latitude: 74.32,
                                    longitude: -56.00,
                                    photo: "imge",
                                    email: "emil",
                                    isActive: true,
                                    imageUrl: nil,
                                    createdAt: Date(),
                                    updatedAt: Date()), onTap:  ()->Void
                     )
}
