//
//  AvailabilitySummary.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
struct AvailabilitySummary {
    let date: Date
    let totalSlots: Int
    let availableSlots: Int
    let bookedSlots: Int
    let breakSlots: Int
    let blockedSlots: Int
    
    var occupancyRate: Double {
        guard totalSlots > 0 else { return 0 }
        return Double(bookedSlots) / Double(totalSlots)
    }
    
    var availabilityRate: Double {
        guard totalSlots > 0 else { return 0 }
        return Double(availableSlots) / Double(totalSlots)
    }
}
