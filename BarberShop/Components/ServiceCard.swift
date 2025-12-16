//
//  ServiceCard.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct ServiceCard: View {
    let service: Service
    
    var body: some View {
        VStack(alignment: .leading,spacing: 8){
            AsyncImage(url: URL(string: service.imageUrl ?? "")){
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                Rectangle()
                    .fill(Color.blue.opacity(0.4))
                    .overlay(
                        Image(systemName: "scissors")
                            .foregroundColor(.blue)
                    )
            }
            .frame(width: 160, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4){
                Text(service.name)
                    .font(.headline)
                    .lineLimit(1)
                HStack{
                    Text("$(\(String(format: "%.3f", service.price)))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(service.durationMinutes) min")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
    }
}
#Preview {
    ServiceCard(service: Service(id: UUID(),
                                 categoryId: UUID(),
                                 name: "Corte",
                                 description: "agregra descripticion",
                                 durationMinutes: 45,
                                 price: 22,
                                 imageUrl: "https://images.unsplash.com/photo-1503951914875-452162b0f3f1",
                                 isActive: true,
                                 createdAt: Date(),
                                 updatedAt: Date())
    )
}
