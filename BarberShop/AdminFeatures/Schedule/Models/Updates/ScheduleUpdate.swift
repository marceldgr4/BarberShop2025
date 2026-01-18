//
//  ScheduleUpdate.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//
import Foundation
import Combine
struct ScheduleUpdate: Encodable {
    let startTime: String
    let endTime: String
    let isAvailable: Bool
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case isAvailable = "is_available"
        case updatedAt = "updated_at"
    }
}
