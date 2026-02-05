//
//  AppointmentAction.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/01/26.
//

import Foundation
import SwiftUI

extension AppointmentDetail {
    enum AppointmentAction {
        case viewDetails
        case cancel
        case reschedule
        case rebook
        case addReview

        var title: String {
            switch self {
            case .viewDetails: return "View Details"
            case .cancel: return "Cancel Appointment"
            case .reschedule: return "Reschedule"
            case .rebook: return "Book Again"
            case .addReview: return "Add Review"
            }
        }

        var icon: String {
            switch self {
            case .viewDetails: return "doc.text"
            case .cancel: return "xmark.circle"
            case .reschedule: return "calendar.badge.clock"
            case .rebook: return "arrow.clockwise"
            case .addReview: return "star.fill"
            }
        }

        var color: Color {
            switch self {
            case .viewDetails: return .blue
            case .cancel: return .red
            case .reschedule: return .brandAccent
            case .rebook: return .green
            case .addReview: return .yellow
            }
        }
    }
}
