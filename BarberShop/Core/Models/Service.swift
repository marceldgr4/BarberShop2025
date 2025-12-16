//
//  Service.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation

struct Service: Identifiable, Codable, Hashable{
    let id: UUID
    let categoryId: UUID
    let name: String
    let description: String
    let durationMinutes: Int
    let price: Double
    let imageUrl: String
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name, description, price
        case categoryId = "category_id"
        case durationMinutes = "duration_minutes"
        case imageUrl = "image_url"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
}

struct ServiceCategory: Identifiable,Codable, Hashable{
    let id:UUID
    let name: String
    let description: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name, description
        case createdAt = "created_at"
    }
}
