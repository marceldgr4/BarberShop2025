//
//  ProfileModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/11/25.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    let fullName: String
    let email: String?
    let avatarUrl: String?
    let phone: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date

        
    enum CodingKeys: String, CodingKey{
        case id, phone, email
        case fullName = "full_name"
        case isActive = "is_active"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
}
