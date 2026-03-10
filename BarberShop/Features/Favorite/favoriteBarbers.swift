//
//  favoriteBarbers.swift
//  BarberShop
//
//  Created by Marcel Diaz Granados Robayo on 9/03/26.
//

import Foundation

struct FavoriteBarbers: Identifiable, Codable{
    let id: UUID
    let userId:UUID
    let barberId:UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case userId = "user_id"
        case barberId = "barber_id"
        case createdAt = "created_at"
    }
}
