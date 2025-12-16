//
//  ServiceItem.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 16/12/25.
//

import SwiftUI

struct ServiceItem: View {
    let service: Service
    let isSelected: Bool
    let active: () -> Void
    var body: some View {
        Button(action: active){
            HStack(spacing: 12){
                AsyncImage(url: URL(string: service.imageUrl ?? "")) {
                    image in image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }placeholder: {
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .overlay(Image(systemName: "scissors")
                            .foregroundColor(.blue)
                        )
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                //MARK: info
                VStack(alignment: .leading, spacing: 4){
                    Text(service.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(service.description ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    HStack{
                        Text("$\(String(format: "%.3f", service.price))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text(".")
                            .foregroundColor(.gray)
                        
                        Text("\(service.durationMinutes) min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                //MARK: Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill": "circle")
                    .foregroundColor(isSelected ? .blue: .gray)
                    .font(.title3)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            )
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2))
        }
    }
}

#Preview {
    ServiceItem(service: Service(id: UUID(),
                                 categoryId: UUID(),
                                 name: "Corte",
                                 description: "corte con maquina y tijera",
                                 durationMinutes: 30,
                                 price: 23,
                                 imageUrl: "nil",
                                 isActive: true,
                                 createdAt: Date(),
                                 updatedAt: Date()),
                isSelected: true,
                active: {})
    .padding()
}
