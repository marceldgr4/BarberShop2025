//
//  BreakTime.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation
struct BreakTime: Identifiable, Codable{
    let id: UUID
    let barberId: UUID
    let breakType: BreakType
    let startTime: String
    let endTime: String
    let dayOfWeek: [Int]
    
    enum CodingKeys: String,CodingKey{
        case id
        case barberId = "barber_id"
        case breakType = "break_type"
        case startTime = "startTime"
        case endTime = "end_Time"
        case dayOfWeek = "day_of_week"
    }
    
    enum BreakType: String, Codable{
        case lunch = "lunch"
        case short = "short"
        case custom = " custom"
        
        var displayName: String{
            switch self{
            case .lunch: return "Almuerzo"
            case .short: return "descanos corto"
            case .custom: return "personalizado"
            }
        }
    
    var icon: String {
                switch self {
                case .lunch: return "fork.knife"
                case .short: return "cup.and.saucer"
                case .custom: return "clock"
                }
            }
        }
        
        var duration: Int {
            guard let start = startTime.toTime(),
                  let end = endTime.toTime() else {
                return 0
            }
            
            let components = Calendar.current.dateComponents([.minute], from: start, to: end)
            return components.minute ?? 0
        }
}
