//
//  AppointmentDetails+Extesion.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/01/26.
//

import Foundation
import SwiftUI

extension AppointmentDetail{
    var structsColor: Color {
        switch statusName.lowercased(){
        case "pending": return .brandAccent
        case "Confirmed": return .blue
        case "in_progress":return .purple
        case "Completed": return .green
        case "Cancelled": return .red

        default: return .gray
        }
    }
    
    var statusIcon: String {
            switch statusName.lowercased() {
            case "pending": return "clock.fill"
            case "confirmed": return "checkmark.circle.fill"
            case "in_progress": return "scissors"
            case "completed": return "checkmark.seal.fill"
            case "cancelled": return "xmark.circle.fill"
            default: return "questionmark.circle.fill"
            }
        }
    var canCancel: Bool {
           ["pending", "confirmed"].contains(statusName.lowercased())
       }
       
       var canReschedule: Bool {
           ["pending", "confirmed"].contains(statusName.lowercased())
       }
       
       var isPast: Bool {
           guard let date = appointmentDate.toDate() else { return false }
           return date < Date()
       }
       
       var isUpcoming: Bool {
           guard let date = appointmentDate.toDate() else { return false }
           let calendar = Calendar.current
           let now = Date()
           let weekFromNow = calendar.date(byAdding: .day, value: 7, to: now)!
           return date >= now && date <= weekFromNow
       }
       
       var formattedDate: String {
           guard let date = appointmentDate.toDate() else { return appointmentDate }
           let formatter = DateFormatter()
           formatter.dateStyle = .long
           formatter.timeStyle = .none
           return formatter.string(from: date)
       }
       
       var formattedTime: String {
           let components = appointmentTime.split(separator: ":")
           guard components.count >= 2 else { return appointmentTime }
           return "\(components[0]):\(components[1])"
       }
   }
