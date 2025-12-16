//
//  BranchViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/12/25.
//

import Foundation
import Combine

@MainActor
class BranchViewModel: ObservableObject {
    @Published var braches: [Branch] = [ ]
    @Published var selectedBranch: Branch?
    @Published var branchHours: [BranchHours] = [ ]
    @Published var barbers: [BarberWithRating] = [ ]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared
    
    func loadBranches () async{
        isLoading = true
        
        do{
            braches = try await supabase.fetchBranches()
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func selectBranch(_ branch: Branch) async {
        selectedBranch = branch
        do{
            async let hoursTask = supabase.fetchBranchHours(branchId: branch.id)
            async let barbersTask = supabase.fetchBarbers(branchId: branch.id)
            
            branchHours = try await hoursTask
            barbers = try await barbersTask
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
