//
//  Cacheable.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
protocol Cacheable: Codable{
    var cacheKey: String {get}
}
