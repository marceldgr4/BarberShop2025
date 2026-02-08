//
//  AppointmentFilter.swift
//  BarberShop
//
//  Created by Assistant on 20/01/26.
//

import Foundation

// MARK: - AppointmentFilter enum (standalone)
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

// MARK: - Extension on AppointmentDetail for convenience
extension AppointmentDetail {
    typealias AppointmentFilter = BarberShop.AppointmentFilter
}
