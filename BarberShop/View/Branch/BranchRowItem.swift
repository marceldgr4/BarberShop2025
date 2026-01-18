//
//  BranchRowItem.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 16/12/25.
//

import SwiftUI

struct BranchRowItem: View {
    let branch: Branch
    
    var body: some View {
        HStack(spacing: 12){
            AsyncImage(url: URL(string: branch.imageUrl ?? "")){
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.orange.opacity(0.3))
                    .overlay(Image(systemName: "building.2")
                        .foregroundColor(.orange)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 12){
                Text(branch.name)
                    .font(.headline)
                Text(branch.address)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 4){
                    Image(systemName: "phone.fill")
                        .font(.caption2)
                    Text(branch.phone)
                        .font(.caption)
                }
                .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    BranchRowItem(branch: Branch(id: UUID(),
                                 name: "Center BarBerShop",
                                 address: "calle 72 # 45-67, Barranquilla",
                                 latitude: 10.9878,
                                 longitude: -74.7889,
                                 phone: "+57 315 xxx xxxx",
                                 email: "Example@prueba.com",
                                 isActive: true,
                                 imageUrl: nil,
                                 createdAt: Date(),
                                 updatedAt: Date()))
}
