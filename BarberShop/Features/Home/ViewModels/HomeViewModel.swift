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
        isLoading = true
        errorMessage = nil
        
        do {
            // Cargar datos en paralelo
            async let branchesTask = branchService.fetchBranches()
            async let servicesTask = serviceService.fetchServices()
            async let promotionsTask = promotionService.fetchActivePromotions()
            async let barbersTask = barberService.fetchBarbers()
            
            // Esperar todos los resultados
            branches = try await branchesTask
            services = try await servicesTask
            promotions = try await promotionsTask
            featuredBarbers = try await barbersTask
            
            // Centrar mapa en la primera sucursal válida
            if let firstBranch = branches.first,
               firstBranch.latitude.isFinite,
               firstBranch.longitude.isFinite {
                mapRegion.center = CLLocationCoordinate2D(
                    latitude: firstBranch.latitude,
                    longitude: firstBranch.longitude
                )
            }
            
            print("<-OK-> HomeViewModel: Data loaded successfully")
            print("<-OK-> Branches: \(branches.count)")
            print("<-OK-> Services: \(services.count)")
            print("<-OK-> Promotions: \(promotions.count)")
            print("<-OK-> Barbers: \(featuredBarbers.count)")
            
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            print("<-X-> HomeViewModel Error: \(error)")
            
            // Imprimir detalles del error para debugging
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("   Data corrupted: \(context)")
                case .keyNotFound(let key, let context):
                    print("   Key '\(key)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("   Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("   Value '\(type)' not found: \(context.debugDescription)")
                @unknown default:
                    print("   Unknown decoding error")
                }
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Select Branch
    func selectBranch(_ branch: Branch) {
        // Validar coordenadas antes de actualizar
        guard branch.latitude.isFinite && branch.longitude.isFinite else {
            print("⚠️ Invalid coordinates for branch: \(branch.name)")
            return
        }
        
        selectedBranch = branch
        mapRegion.center = CLLocationCoordinate2D(
            latitude: branch.latitude,
            longitude: branch.longitude
        )
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
}
