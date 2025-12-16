//
//  Review.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation
struct Review: Identifiable, Codable{
    let id: UUID
    let userId: UUID
    let branchId: UUID
    let barberId:UUID
    let appointmentId: UUID?
    let rating:Int
    let comment: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, rating, comment
        case userId = "user_id"
        case branchId = "branch_id"
        case barberId = "barber_id"
        case appointmentId = "appointment_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
