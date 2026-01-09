//
//  BreakTimeUpdate_schedule.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
 struct BreakTimeUpdate: Encodable {
    let startTime: String
    let endTime: String
    let daysOfWeek: [Int]
    
    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case daysOfWeek = "days_of_week"
    }
}
