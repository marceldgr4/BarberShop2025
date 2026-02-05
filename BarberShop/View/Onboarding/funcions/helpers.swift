//
//  helpers.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/01/26.
//

import Foundation
import Combine
import CoreLocation
import UserNotifications
import SwiftUI

extension OnboardingView {
    
    var buttonTitle: String {
        if currentPage == pages.count - 1 {
            return "Get Started"
        } else if currentPage == 3 {
            return "Enable Notifications"
        } else if currentPage == 4 {
            return "Allow Location"
        } else {
            return "Continue"
        }
    }
    
    var permissionMessage: String {
        switch permissionType {
        case .notifications:
            return "We'll send you appointment reminders and special offers. You can change this anytime in Settings."
        case .location:
            return "Allow location access to find barbershops near you and get accurate directions."
        case .none:
            return ""
        }
    }
    
    // MARK: - Actions
    func handleButtonTap() {
        print("🔘 Button tapped on page: \(currentPage)")
        print("📄 Total pages: \(pages.count)")
        print("📄 Last page index: \(pages.count - 1)")
        
        // ✅ FIX: Verificar primero si estamos en la última página
        if currentPage == pages.count - 1 {
            print("✅ Last page detected - completing onboarding")
            completeOnboarding()
            return
        }
        
        // ✅ FIX: Revisar permisos SOLO en las páginas específicas Y que NO sean la última
        if currentPage == 3 && currentPage != pages.count - 1 {
            // Página de notificaciones
            print("📬 Notifications page - showing alert")
            permissionType = .notifications
            showPermissionAlert = false
            return
        }
        
        // ✅ FIX: Si llegamos aquí, simplemente avanzar a la siguiente página
        print("➡️ Moving to next page")
        moveToNextPage()
    }
    
    func moveToPreviousPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if currentPage > 0 {
                currentPage -= 1
                print("⬅️ Moved to page: \(currentPage)")
            }
        }
    }
    
    func moveToNextPage() {
        withAnimation(.spring(response: 0.5)) {
            if currentPage < pages.count - 1 {
                currentPage += 1
                print("➡️ Moved to page: \(currentPage)")
            } else {
                print("⚠️ Already at last page, calling completeOnboarding")
                completeOnboarding()
            }
        }
    }
    
    func skipOnboarding() {
        print("⏭️ Skipping onboarding")
        withAnimation(.easeInOut(duration: 0.3)) {
            completeOnboarding()
        }
    }
    
    func completeOnboarding() {
        print("🎉 Completing onboarding...")
        print("📱 Current page: \(currentPage)")
        print("📱 Total pages: \(pages.count)")
        print("📱 Setting UserDefaults.hasCompletedOnboarding = true")
        
        UserDefaults.standard.hasCompletedOnboarding = true
        
        print("🔄 Setting isFirstLaunch = false")
        withAnimation(.spring(response: 0.6)) {
            isFirstLaunch = false
        }
        
        // Verificar que se guardó correctamente
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("✓ UserDefaults check: \(UserDefaults.standard.hasCompletedOnboarding)")
            print("✓ isFirstLaunch check: \(self.isFirstLaunch)")
        }
    }
    
    func handlePermission() {
        print("🔐 Handling permission: \(String(describing: permissionType))")
        switch permissionType {
        case .notifications:
            requestNotificationPermission()
        case .location:
            requestLocationPermission()
        case .none:
            moveToNextPage()
        }
    }
    
    func requestNotificationPermission() {
        print("📬 Requesting notification permission...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permission granted")
                } else {
                    print("❌ Notification permission denied")
                }
                self.moveToNextPage()
            }
        }
    }
    
    func requestLocationPermission() {
        print("📍 Requesting location permission...")
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        
        // Esperar un momento y luego avanzar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("📍 Location permission requested, moving to next page")
            self.moveToNextPage()
        }
    }
}
