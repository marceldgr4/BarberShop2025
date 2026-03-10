//
//  Product.swift
//  BarberShop
//
//  Created by Marcel Diaz Granados Robayo on 9/03/26.
//

import Foundation
struct Product: Identifiable,Codable{
    let id: UUID
    let barbershopId: UUID
    let name: String
    let description: String?
    let price: Double
    let stock: Int
    let isActive: Bool
    let createdAt : Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name, stock,description, price
        case barbershopId = "barbershop_id"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "update_at"
    }
}
