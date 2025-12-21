import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
class HomeViewModel: ObservableObject {
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
    
    private let supabase = SupabaseManager.shared
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let branchesTask = supabase.fetchBranches()
            async let servicesTask = supabase.fetchServices()
            async let promotionsTask = supabase.fetchActivePromotions()
            async let barbersTask = supabase.fetchBarbers()
            
            branches = try await branchesTask
            services = try await servicesTask
            promotions = try await promotionsTask
            featuredBarbers = try await barbersTask
            
            // Center map on first branch
            if let firstBranch = branches.first {
                mapRegion.center = CLLocationCoordinate2D(
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
        selectedBranch = branch
        mapRegion.center = CLLocationCoordinate2D(
            latitude: branch.latitude,
            longitude: branch.longitude
        )
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
}
