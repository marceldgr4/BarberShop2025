//
//  ScheduleOverride.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation
struct ScheduleOverride: Identifiable, Codable {
    let id: UUID
    let barberId: UUID
    let date: String 
    let reason: OverrideReason
    let customReason: String?
    let isAvailable: Bool
    let startTime: String?
    let endTime: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case barberId = "barber_id"
        case date, reason
        case customReason = "custom_reason"
        case isAvailable = "is_available"
        case startTime = "start_time"
        case endTime = "end_time"
        case createdAt = "created_at"
    }
    
    enum OverrideReason: String, Codable {
        case vacation = "vacation"
        case sick = "sick"
        case personal = "personal"
        case training = "training"
        case custom = "custom"
        
        var displayName: String {
            switch self {
            case .vacation: return "Vacaciones"
            case .sick: return "Enfermedad"
            case .personal: return "Asunto Personal"
            case .training: return "Capacitación"
            case .custom: return "Otro"
            }
        }
        
        var icon: String {
            switch self {
            case .vacation: return "airplane"
            case .sick: return "cross.case"
            case .personal: return "person"
            case .training: return "book"
            case .custom: return "note.text"
            }
        }
    }
    
    var displayReason: String {
        if case .custom = reason, let custom = customReason {
            return custom
        }
        return reason.displayName
    }
}
