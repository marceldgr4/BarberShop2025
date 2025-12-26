//
//  BreanchMapMarker.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

//
//  BranchMapMarker.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/12/25.
//

import SwiftUI

struct BranchMapMarker: View {
    let branch: Branch
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    // Círculo exterior con sombra
                    Circle()
                        .fill(Color.white)
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    // Círculo interior con el ícono
                    Circle()
                        .fill(Color.brandOrange)
                        .frame(width: 38, height: 38)
                    
                    // Ícono
                    Image(systemName: "scissors")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Flecha apuntando hacia abajo
                Triangle()
                    .fill(Color.white)
                    .frame(width: 12, height: 8)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .offset(y: -4)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview("Single Marker") {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
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
                print("Marker tapped")
            }
        )
    }
}

#Preview("Multiple Markers") {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        HStack(spacing: 30) {
            BranchMapMarker(
                branch: Branch(
                    id: UUID(),
                    name: "Central",
                    address: "Calle 72",
                    latitude: 10.9878,
                    longitude: -74.7889,
                    phone: "+57 300 123 4567",
                    email: "central@barbershop.com",
                    isActive: true,
                    imageUrl: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                onTap: {}
            )
            
            BranchMapMarker(
                branch: Branch(
                    id: UUID(),
                    name: "Norte",
                    address: "Calle 84",
                    latitude: 11.0205,
                    longitude: -74.8029,
                    phone: "+57 300 123 4568",
                    email: "norte@barbershop.com",
                    isActive: true,
                    imageUrl: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                onTap: {}
            )
        }
    }
}
