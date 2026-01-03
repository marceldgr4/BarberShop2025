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
    @Published var branches: [Branch] = [ ]
    @Published var selectedBranch: Branch?
    @Published var branchHours: [BranchHours] = [ ]
    @Published var barbers: [BarberWithRating] = [ ]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    //private let supabase = SupabaseManager.shared
    private let branchService = BranchService()
    private let barberService = BarberService()
    func loadBranches () async{
        isLoading = true
        
        do{
            branches = try await branchService.fetchBranches()
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func selectBranch(_ branch: Branch) async {
        selectedBranch = branch
        do{
            async let hoursTask = branchService.fetchBranchHours(branchId: branch.id)
            async let barbersTask = barberService.fetchBarbers(branchId: branch.id)
            
            branchHours = try await hoursTask
            barbers = try await barbersTask
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
