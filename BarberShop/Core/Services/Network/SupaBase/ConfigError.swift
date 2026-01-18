//
//  ConfigError.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
enum ConfigurationError: Error{
    case missingKey(String)
    case invalidURL(String)
}
