//
//  MapViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo
//

import Foundation
import MapKit
import Combine

@MainActor
class MapViewModel: ObservableObject {
    @Published var branches: [Branch] = []
    @Published var region: MKCoordinateRegion
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    //private let supabase = SupabaseManager.shared
    private let branchService = BranchService()
    private var allBranches: [Branch] = []
    
    init() {
        // Inicializar con coordenadas válidas (Barranquilla por defecto)
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 10.9878, longitude: -74.7889),
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    }
    
    var filteredBranches: [Branch] {
        if searchText.isEmpty {
            return allBranches
        }
        return allBranches.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadBranches() async {
        isLoading = true
        errorMessage = nil
        
        do {
            allBranches = try await branchService.fetchBranches()
            branches = allBranches
            
            // Solo centrar si hay sucursales válidas
            if let firstBranch = branches.first,
               firstBranch.latitude.isFinite,
               firstBranch.longitude.isFinite {
                region.center = CLLocationCoordinate2D(
                    latitude: firstBranch.latitude,
                    longitude: firstBranch.longitude
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func selectBranch(_ branch: Branch) {
        // Validar coordenadas antes de actualizar
        guard branch.latitude.isFinite && branch.longitude.isFinite else {
            return
        }
        
        region.center = CLLocationCoordinate2D(
            latitude: branch.latitude,
            longitude: branch.longitude
        )
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
    
    func recenterMap() {
        if let firstBranch = branches.first,
           firstBranch.latitude.isFinite,
           firstBranch.longitude.isFinite {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstBranch.latitude,
                    longitude: firstBranch.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            )
        }
    }
}
