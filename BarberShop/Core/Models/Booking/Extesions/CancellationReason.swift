//
//  CancellationReason.swift
//  BarberShop
//
//  Created by Assistant on 20/01/26.
//

import Foundation

// MARK: - CancellationReason enum (used in AppointmentServiceExtended)
enum CancellationReason: String, Codable, CaseIterable {
    case personalIssue = "Personal Issue"
    case foundAnotherBarber = "Found Another Barber"
    case timeConflict = "Time Conflict"
    case tooExpensive = "Too Expensive"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .personalIssue: return "person.fill"
        case .foundAnotherBarber: return "scissors"
        case .timeConflict: return "clock.fill"
        case .tooExpensive: return "dollarsign.circle.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

// MARK: - Extension on AppointmentDetail for convenience
extension AppointmentDetail {
    typealias CancellationReason = BarberShop.CancellationReason
}
