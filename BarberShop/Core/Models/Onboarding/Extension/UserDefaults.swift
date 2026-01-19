//
//  UserDefaults+Extension.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    var hasCompletedOnboarding: Bool {
        get {
            return bool(forKey: Keys.hasCompletedOnboarding)
        }
        set {
            set(newValue, forKey: Keys.hasCompletedOnboarding)
            synchronize() // Fuerza el guardado inmediato
            print("💾 UserDefaults saved: hasCompletedOnboarding = \(newValue)")
        }
    }
}
