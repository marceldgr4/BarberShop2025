//
//  BarberWithRating.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation

struct BarberWithRating: Identifiable, Codable {
    let id: UUID
    let branchId: UUID
    let name: String
    let photoUrl: String?
    let specialty: String?

    let isActive: Bool?
    let rating: Double?
    let totalReviews: Int?

    enum CodingKeys: String, CodingKey {
        case id, rating
        case branchId = "branch_id"
        case name = "full_name"
        case photoUrl = "photo_url"
        case specialty
        case isActive = "is_active"
        case totalReviews = "total_reviews"
    }
}
