//
//  UserRole.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 24/12/25.
//

import Foundation
struct Role: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String?
    let createdAt: Date
    
    
    enum CodingKeys: String, CodingKey {
        case id, description,name
        case createdAt = "created_at"
     
    }
}

struct UserRole : Identifiable, Codable{
    let id: UUID
    let userId: UUID
    let roleId: UUID
    let barbershopId: UUID?
    let createdAt: Date
    
    let role: Role?
    
    enum CodingKeys: String, CodingKey{
        case id
        case userId = "user_id"
        case roleId = "role_id"
        case barbershopId = "barbershop_id"
        case createdAt = "created_at"
        case role = "roles"
    }
    
}
