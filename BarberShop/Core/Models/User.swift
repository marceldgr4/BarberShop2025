//
//  ProfileModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/11/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let fullName: String
    let phone: String?
    let email: String?
    let photoUrl: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    let rolId: UUID?
        
    enum CodingKeys: String, CodingKey{
        case id,email, phone
        case fullName = "full_name"
        case isActive = "is_active"
        case photoUrl = "photo_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rolId = "rol_id"
    }
}
