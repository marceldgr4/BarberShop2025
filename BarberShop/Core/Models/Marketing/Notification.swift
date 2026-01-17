//
//  Notification.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
import UserNotifications

struct Notification: Identifiable, Codable{
    let id:UUID
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    var isRead: Bool
    let actionURL: String?
    let metaData:[String: String]?
    
    enum NotificationType: String, Codable{
        case promotion = "promotion"
        case appointment = "appointment"
        case cancellation = "cancellation"
        case reminder = "remindir"
        case announcement = "announcement"
        
        var icon: String {
                    switch self {
                    case .promotion: return "tag.fill"
                    case .appointment: return "calendar.badge.plus"
                    case .cancellation: return "xmark.circle.fill"
                    case .reminder: return "bell.fill"
                    case .announcement: return "megaphone.fill"
                    }
                }
                
        var color: String {
            switch self {
            case .promotion: return "#EE8F40"
            case .appointment: return "#007AFF"
            case .cancellation: return "#FF3B30"
            case .reminder: return "#FF9500"
            case .announcement: return "#5856D6"
            }
        }
    }
}
