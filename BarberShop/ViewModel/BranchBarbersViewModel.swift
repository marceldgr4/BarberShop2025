//
//  BranchBarbersViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 24/12/25.
//

import Foundation
import Combine
@MainActor
class BranchBarbersViewModel: ObservableObject {
    @Published var barbers: [BarberWithRating] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    //private let supabase = SupabaseManager.shared
    private let branchService = BranchService()
    private let barberService = BarberService()
    func loadBarbers(for branchId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            barbers = try await barberService.fetchBarbers(branchId: branchId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
