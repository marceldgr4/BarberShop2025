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
    let email: String
    let photoUrl: String?
    let isActive: Bool
    let createdAt: Date
    let updateAt: Date
        
    enum CodingKeys: String, CodingKey{
        case id,emil,phone
        case fullName = "full_name"
        case isActive = "is_active"
        case photoUrl = "photo_url"
        case createadAt = "created_at"
        case updateAt = "update_at"
    }
}
