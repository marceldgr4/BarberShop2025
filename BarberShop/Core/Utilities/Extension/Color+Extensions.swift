//
//  Color.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/12/25.
//


import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // MARK: - New Brand Colors
    static let brandPrimary = Color(hex: "#676F6D")      // Gray-blue
    static let brandSecondary = Color(hex: "#424769")    // Dark blue-gray
    static let brandDark = Color(hex: "#2D3250")         // Darker blue-gray
    static let brandAccent = Color(hex: "#F6B17A")       // Peachy accent
    static let brandWhite = Color(hex: "#FFFFFF")        // White
    
    // Legacy support - maps to new primary color
    static let brandOrange = Color.brandAccent
    
    static let brandGradient = LinearGradient(
        colors: [Color.brandSecondary, Color.brandPrimary],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let brandGradientVertical = LinearGradient(
        colors: [Color.brandSecondary, Color.brandDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
