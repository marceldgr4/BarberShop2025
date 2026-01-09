//
//  CacheEntry.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation

struct CacheEntry <T: Codable>: Codable{
    let value: T
    let timestamp: Date
    let expirationInterval: TimeInterval
    
    var isExpired: Bool{
        Date().timeIntervalSince(timestamp) > expirationInterval
    }
}

struct AnyCodable: Codable{
    let value: Any
    init(_ value: Any) {
        self.value = value
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let bool = try? container.decode(Bool.self) { value = bool }
            else if let int = try? container.decode(Int.self) { value = int }
            else if let double = try? container.decode(Double.self) { value = double }
            else if let string = try? container.decode(String.self) { value = string }
            else { value = "" }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            if let bool = value as? Bool { try container.encode(bool) }
            else if let int = value as? Int { try container.encode(int) }
            else if let double = value as? Double { try container.encode(double) }
            else if let string = value as? String { try container.encode(string) }
        }
    }
