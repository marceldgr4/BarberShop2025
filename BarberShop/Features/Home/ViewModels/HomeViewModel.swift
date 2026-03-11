//
//  HomeViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo
//

import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Services
    private let branchService = BranchService()
    private let serviceService = ServiceService()
    private let promotionService = PromotionService()
    private let barberService = BarberService()
    
    // MARK: - Published Properties
    @Published var branches: [Branch] = []
    @Published var services: [Service] = []
    @Published var promotions: [Promotion] = []
    @Published var featuredBarbers: [BarberWithRating] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedBranch: Branch?
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10.9878, longitude: -74.7889),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // MARK: - Load Home Data
    func loadHomeData() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            async let branchesTask = branchService.fetchBranches()
            async let servicesTask = serviceService.fetchServices()
            async let promotionsTask = promotionService.fetchActivePromotions()
            async let barbersTask = barberService.fetchBarbers()
            
            // ✅ Esperar todos los resultados una sola vez
            let (fetchedBranches, fetchedServices, fetchedPromotions, fetchedBarbers) = try await (
                branchesTask, servicesTask, promotionsTask, barbersTask
            )
            
            // ✅ Asignar los resultados ya resueltos, sin try await
            await MainActor.run {
                branches = fetchedBranches
                services = fetchedServices
                promotions = fetchedPromotions
                featuredBarbers = fetchedBarbers
                
                // Centrar mapa
                if let firstBranch = fetchedBranches.first,
                   let lat = firstBranch.latitude,
                   let lng = firstBranch.longitude,
                   lat.isFinite && lng.isFinite {
                    mapRegion.center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                }
                
                isLoading = false
            }
            
           
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load data: \(error.localizedDescription)"
                isLoading = false
            }
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value '\(type)' not found: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
        }
    }
    
    // MARK: - Select Branch
    func selectBranch(_ branch: Branch) {
        // Validar coordenadas antes de actualizar
        guard branch.latitude!.isFinite && branch.longitude!.isFinite else {
            print("⚠️ Invalid coordinates for branch: \(branch.name)")
            return
        }
        
        selectedBranch = branch
        mapRegion.center = CLLocationCoordinate2D(
            latitude: branch.latitude!,
            longitude: branch.longitude!
        )
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
}
