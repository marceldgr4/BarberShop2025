//
//  BarberSchedule.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation

struct BarberSchedule: Identifiable, Codable{
    let id: UUID
    let barberId: UUID
    let dayOfWeek: Int
    let startTime: String
    let endTime: String
    let isAvailable: Bool
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case barberId = "barber_id"
        case dayOfWeek = "day_of_week"
        case startTime = "start_time"
        case endTime = "end_time"
        case isAvailable = "is_available"
        case createdAt = "created_at"
        case updatedAt = "update_at"
    }
    
    var dayName: String{
        let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday", "Sunday"]
    return days[dayOfWeek]
    }
    var timeRange: String{
        "\(startTime)- \(endTime)"
    }
}
