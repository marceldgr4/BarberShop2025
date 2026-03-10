//
//  Barbershop.swift
//  BarberShop
//
//  Created by Marcel Diaz Granados Robayo on 9/03/26.
//

import Foundation

struct Barbershop: Identifiable, Codable, Hashable{
    let id: UUID
    let name: String
    let logoUrl: String?
    let email: String?
    let phone: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt:Date
    
    enum CodingKeys: String, CodingKey{
        case id, name, email, phone
        case logoUrl = "logo_url"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
