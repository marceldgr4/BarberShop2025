//
//  OverrideUpdate_schedule.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
struct ScheduleOverrideUpdate: Encodable {
    let isAvailable: Bool
    let startTime: String?
    let endTime: String?
    
    enum CodingKeys: String, CodingKey {
        case isAvailable = "is_available"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
