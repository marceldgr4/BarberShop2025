//
//  UserRole.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 24/12/25.
//

import Foundation
struct UserRole: Identifiable, Codable {
    let id: UUID
    let roleName: String
    let description: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case roleName = "role_name"
     
    }
}
