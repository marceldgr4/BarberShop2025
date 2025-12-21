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
    let specialtyId: UUID
    let name: String
    let photoUrl: String
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name
        case branchId = "branch_id"
        case specialtyId = "specialty_id"
        case photoUrl = "photo_url"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
        
    }
}
struct BarberSpecialty: Identifiable, Codable, Hashable{
    let id: UUID
    let name: String
    let description: String
    
}

struct BarberRating: Codable {
    let id: UUID
    let barberId: UUID
    let averageRating: Double
    let totalReviews : Int
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case barberId = "barber_id"
        case averageRating = "average_rating"
        case totalReviews = "total_reviews"
        case updatedAt = " updated_at"
    }
}

