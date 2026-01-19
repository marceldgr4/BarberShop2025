//
//  OnboardingModels.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//
import Foundation
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
    let showSkip: Bool
}

