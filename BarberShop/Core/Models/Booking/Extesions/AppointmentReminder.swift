//
//  AppointmentReminder.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/01/26.
//

import Foundation
extension AppointmentDetail{
    struct AppointmentReminder: Identifiable {
        let id = UUID()
        let appointmentId: UUID
        let reminderTime: Date
        let message: String
        var isScheduled: Bool
    }
}
