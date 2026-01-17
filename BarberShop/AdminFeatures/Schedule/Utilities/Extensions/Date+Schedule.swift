//
//  Extension_Schedule.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 7/01/26.
//

import Foundation
import Combine

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        return DateFormatter.cached(with: format).date(from: self)
    }
    
    func toTime() -> Date? {
        return DateFormatter.cached(with: "HH:mm").date(from: self)
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        return DateFormatter.cached(with: format).string(from: self)
    }
    
    func toTimeString() -> String {
        return DateFormatter.cached(with: "HH:mm").string(from: self)
    }
}


extension DateFormatter {
    private static var cache: [String: DateFormatter] = [:]
    
    static func cached(with format: String) -> DateFormatter {
        if let cachedFormatter = cache[format] {
            return cachedFormatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        // Fijar el locale para evitar problemas con formatos de 12/24h del sistema
        formatter.locale = Locale(identifier: "en_US_POSIX")
        cache[format] = formatter
        return formatter
    }
}
