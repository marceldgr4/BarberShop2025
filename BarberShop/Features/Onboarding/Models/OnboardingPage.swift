//
//  OnboardingPage.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import Foundation
import SwiftUI

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to BarberShop",
            description: "Find the best barbers in your area and book appointments with ease",
            imageName: "scissors.circle.fill",
            backgroundColor: Color.brandSecondary,
            showSkip: true
        ),
        OnboardingPage(
            title: "Discover Top Barbers",
            description:
                "Browse through highly rated barbers and check their reviews from real customers",
            imageName: "person.3.fill",
            backgroundColor: Color.brandPrimary,
            showSkip: true
        ),
        OnboardingPage(
            title: "Book in Seconds",
            description: "Select your preferred barber, service, and time slot in just a few taps",
            imageName: "calendar.badge.plus",
            backgroundColor: Color.brandDark,
            showSkip: true
        ),
        OnboardingPage(
            title: "Get Notified",
            description:
                "Receive appointment reminders and special offers from your favorite barbers",
            imageName: "bell.badge.fill",
            backgroundColor: Color.brandSecondary,
            showSkip: true
        ),
        OnboardingPage(
            title: "Find Nearby Locations",
            description: "Discover barbershops near you and get directions instantly",
            imageName: "map.fill",
            backgroundColor: Color.brandPrimary,
            showSkip: true
        ),
    ]
}
