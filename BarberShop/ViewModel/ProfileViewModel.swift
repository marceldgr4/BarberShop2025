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
    
   // private let supabase = SupabaseManager.shared
    private let profile = AuthenticationService()
    private let appointmentService = AppointmentService()
    private let favoriteService = FavoriteService()
    
    
    func loadProfile() async {
        isLoading = true
        
        do{
            async let userTask = profile.getCurrentUser()
            async let appointmentsTask = appointmentService.fecthUserAppointments()
            async let favoritesTask = favoriteService.fetchFavoriteBarbers()
            
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
            try await favoriteService.toggleFavoriteBarber(barberId: barberId)
            await loadProfile()
        }catch{
            errorMessage = error.localizedDescription
        }
        
    }
    

}
