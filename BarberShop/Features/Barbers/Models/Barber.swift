//
//  Barber.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 27/11/25.
//

import Foundation
import CoreLocation 

struct Barber: Identifiable, Codable, Hashable {
    let id: UUID
    let branchId: UUID
    let userId: UUID?
    let fullName: String
    let photoUrl: String?
    let specialty: String?
    
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case branchId = "branch_id"
        case userId = "user_id"
        case fullName = "full_name"
        case photoUrl = "photo_url"
        case specialty
        
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
        
    }
}


struct BarberState: Codable {
    let barberId: UUID
    let averageRating: Double
    let totalReviews : Int
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        
        case barberId = "barber_id"
        case averageRating = "average_rating"
        case totalReviews = "total_reviews"
        case updatedAt = " updated_at"
    }
}

