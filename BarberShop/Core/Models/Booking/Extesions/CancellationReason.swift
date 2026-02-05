//
//  CancellationReason.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/01/26.
//

import Foundation
extension AppointmentDetail{
    enum CancellationReason: String, CaseIterable {
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
}
