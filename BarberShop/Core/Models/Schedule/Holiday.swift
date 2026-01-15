//
//  holiday.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation
struct Holiday: Identifiable, Codable{
    let id: UUID
    let name: String
    let date: String
    let isRecurring: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, name,date
        case isRecurring = "is_recurring"
        case createdAt = "created_at"
        
    }
    var formattedDate: String{
        guard let date = date.toDate() else{
            return self.date
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,d 'de' MMM"
        formatter.locale = Locale(identifier: "es_Es")
        return formatter.string(from: date)
    }
    var icon: String {
        switch name.lowercased() {
        case let n where n.contains("navidad"): return "gift.fill"
        case let n where n.contains("año nuevo"): return "party.popper.fill"
        case let n where n.contains("independencia"): return "flag.fill"
        case let n where n.contains("trabajo"): return "hammer.fill"
        default: return "calendar"
        }
    }
}
