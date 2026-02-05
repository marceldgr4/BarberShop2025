//
//  AppointmentFilter.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/01/26.
//

import Foundation
extension AppointmentDetail{
    enum AppointmentFilter: String, CaseIterable {
        case all = "All"
        case upcoming = "Upcoming"
        case past = "Past"
        case cancelled = "Cancelled"
        
        var icon: String {
            switch self {
            case .all: return "calendar"
            case .upcoming: return "calendar.badge.clock"
            case .past: return "calendar.badge.checkmark"
            case .cancelled: return "calendar.badge.exclamationmark"
            }
        }
    }
}
