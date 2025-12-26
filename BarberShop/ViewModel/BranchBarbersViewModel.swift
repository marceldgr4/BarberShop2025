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
    
    private let supabase = SupabaseManager.shared
    
    func loadBarbers(for branchId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            barbers = try await supabase.fetchBarbers(branchId: branchId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
