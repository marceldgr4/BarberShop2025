//
//  UserUpdate.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 25/12/25.
//

import Foundation

struct UserUpdate: Encodable {
    let fullName: String?
    let phone: String?
    let photoUrl: String?
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case phone
        case photoUrl = "photo_url"
        case updatedAt = "updated_at"
    }
}
