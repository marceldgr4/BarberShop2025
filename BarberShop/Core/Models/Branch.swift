//
//  Branch.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation

struct Branch: Identifiable, Codable, Hashable{
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phone: String
    let email: String?
    let isActive: Bool
    let imageUrl: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name,    address, latitude, longitude,
         phone,  email
        case isActive = "is_active"
        case imageUrl = "image_Url"
        case createdAt = "created_at"
        case updatedAt = "update_at"
    }
}


struct BranchHours: Identifiable, Codable{
    let id: UUID
    let branchId: UUID
    let dayOfWeek: Int
    let openingTime: String
    let closingTime: String
    let isOpen: Bool
    
    enum CodingKeys: String, CodingKey{
        case id
        case branchId = "branch_id"
        case dayOfWeek = "day_of_week"
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case isOpen = "is_open"
    }
}
