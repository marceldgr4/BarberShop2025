//
//  CachePolicy.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
struct CachePolicy{
    let expirationInterval: TimeInterval
    
    static let short = CachePolicy(expirationInterval: 5 * 60)
    static let medium = CachePolicy(expirationInterval: 30 * 60)
    static let long = CachePolicy(expirationInterval: 60 * 60)
    static let persistent = CachePolicy(expirationInterval: .infinity)
}
