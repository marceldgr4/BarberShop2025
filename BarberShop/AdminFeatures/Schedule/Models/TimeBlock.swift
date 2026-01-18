//
//  TimeBlock.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation

struct TimeBlock: Identifiable, Codable, Hashable{
    let id: UUID
    let barberId: UUID
    let date: String
    let startTime: String
    let endTime: String
    let isBooked: Bool
    let appointmentId: UUID?
    let blockType: BlockType
    
    
    enum CodingKeys: String, CodingKey{
        case id, date
        case barberId  = "barber_id"
        case startTime = "start_time"
        case endTime = "end_star"
        case isBooked = "is_booked"
        case appointmentId = "appointment_id"
        case blockType = "block_type"
        
    }
    
    enum BlockType: String, Codable{
        case available = "avilable"
        case booked = "booked"
        case `break` = "break"
        case blocked = "bloked"
        
        var color: String {
                    switch self {
                    case .available: return "#34C759"
                    case .booked: return "#FF3B30"
                    case .break: return "#FF9500"
                    case .blocked: return "#8E8E93"
                    }
                }
                
                var icon: String {
                    switch self {
                    case .available: return "checkmark.circle.fill"
                    case .booked: return "person.fill"
                    case .break: return "cup.and.saucer.fill"
                    case .blocked: return "xmark.circle.fill"
                    }
                }
            }
    var dateTime : Date?{
        let dateTimeString = "\(date)\(startTime)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: dateTimeString)
    }
}
