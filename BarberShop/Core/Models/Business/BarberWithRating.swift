//
//  BarberWithRating.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation

struct BarberWithRating: Identifiable, Codable{
    let id:UUID
    let branchId: UUID
    let specialtyId: UUID?
    let name: String
    let photoUrl: String?
    let isActive: Bool?
    let rating: Double?
    let totalReviews: Int?
    
    enum CodingKeys: String, CodingKey{
        case id, name, rating
        case branchId = "branch_id"
        case photoUrl = "photo_url"
        case specialtyId = "specialty_id"
        case isActive = "is_active"
        case totalReviews = "total_reviews"
    }
}
