//
//  ProfileViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 3/12/25.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
   
    
    @Published var user: User?
    @Published var appointments: [AppointmentDetail] = []
    @Published var favoriteBarbers: [BarberWithRating] = [ ]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSaving = false
    
    private let supabase = SupabaseManager.shared
    
    func loadProfile() async {
        isLoading = true
        
        do{
            async let userTask = supabase.getCurrentUser()
            async let appointmentsTask = supabase.fecthUserAppointments()
            async let favoritesTask = supabase.fetchFavoriteBarbers()
            
            user = try await userTask
            appointments = try await appointmentsTask
            favoriteBarbers = try await favoritesTask
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func toggleFavorite(barberId: UUID) async {
        do{
            try await supabase.toggleFavoriteBarber(barberId: barberId)
            await loadProfile()
        }catch{
            errorMessage = error.localizedDescription
        }
        
    }
    

}
