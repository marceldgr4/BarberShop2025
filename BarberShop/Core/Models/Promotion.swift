//
//  Promotion.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation
struct Promotion: Identifiable, Codable{
    let id: UUID
    let title: String
    let description: String?
    let discountPercentage: Double?
    let startDate: String
    let endDate: String
    let isActive:Bool
    let imageUrl: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, title,description
        case discountPercentage = "discount_percentage"
        case startDate = "start_date"
        case endDate = "end_date"
        case isActive = "is_active"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
