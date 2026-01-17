//
//  ExtencionSupabaseManager.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import Foundation
extension SupabaseManagerSecure{
    
    // MARK: - Authentication Methods
    
    func getCurrentuser() async throws -> User?{
        let authService = AuthenticationService(client: client,decoder: decoder)
        return try await authService.getCurrentUser()
    }
    
    func signUp(email: String, password: String, fullName: String, phone: String) async throws -> User?{
        let authService = AuthenticationService(client: client, decoder: decoder)
        return try await authService.signUp(email: email, password: password, fullName: fullName, phone: phone)
    }
    
    func signIn(email: String, password: String) async throws -> String {
    let authService = AuthenticationService(client: client, decoder: decoder)
        return try await authService.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        let authService = AuthenticationService(client: client, decoder: decoder)
        try await authService.signOut()
    }
    
    func resetuser(email: String) async throws{
        let authService = AuthenticationService(client: client, decoder: decoder)
        try await authService.resetPassword(email: email)
    }
    
    func UpdateUser( userId: UUID, fullName: String?, phone: String?, photoUrl: String? = nil) async throws{
        let authService = AuthenticationService(client: client,decoder: decoder)
        try await authService.updateUser(userId: userId, fullName: fullName, phone: phone, photoUrl: photoUrl)
    }
    
    // MARK: - Branch Methods
    
    func fetchBranches() async throws ->[Branch] {
        let branchService = BranchService(client: client, decoder: decoder)
        return try await branchService.fetchBranches()
    }
    
    func fetchBranchHours(branchId: UUID) async throws -> [BranchHours] {
            let branchService = BranchService(client: client, decoder: decoder)
            return try await branchService.fetchBranchHours(branchId: branchId)
        }
        
        // MARK: - Barber Methods
        func fetchBarbers(branchId: UUID? = nil) async throws -> [BarberWithRating] {
            let barberService = BarberService(client: client)
            return try await barberService.fetchBarbers(branchId: branchId)
        }
        
        // MARK: - Service Methods
        func fetchServices() async throws -> [Service] {
            let serviceService = ServiceService(client: client, decoder: decoder)
            return try await serviceService.fetchServices()
        }
        
        func fecthServiceCategories() async throws -> [ServiceCategory] {
            let serviceService = ServiceService(client: client, decoder: decoder)
            return try await serviceService.fecthServiceCategories()
        }
    
    func createAppointment(
            branchId: UUID,
            barberId: UUID,
            serviceId: UUID,
            date: String,
            time: String,
            price: Double,
            notes: String?
        ) async throws -> Appointment {
            let appointmentService = AppointmentService(client: client)
            return try await appointmentService.createAppointment(
                branchId: branchId,
                barberId: barberId,
                serviceId: serviceId,
                date: date,
                time: time,
                price: price,
                notes: notes
            )
        }
        
        func fecthUserAppointments() async throws -> [AppointmentDetail] {
            let appointmentService = AppointmentService(client: client)
            return try await appointmentService.fecthUserAppointments()
        }
        
        // MARK: - Promotion Methods
        func fetchActivePromotions() async throws -> [Promotion] {
            let promotionService = PromotionService(client: client, decoder: decoder)
            return try await promotionService.fetchActivePromotions()
        }
        
        // MARK: - Favorite Methods
        func toggleFavoriteBarber(barberId: UUID) async throws {
            let favoriteService = FavoriteService(client: client)
            try await favoriteService.toggleFavoriteBarber(barberId: barberId)
        }
        
        func fetchFavoriteBarbers() async throws -> [BarberWithRating] {
            let favoriteService = FavoriteService(client: client)
            return try await favoriteService.fetchFavoriteBarbers()
        }
        
        // MARK: - Review Methods
        func createReview(
            branchId: UUID,
            barberId: UUID,
            appointmentId: UUID?,
            rating: Int,
            comment: String?
        ) async throws {
            let reviewService = ReviewsService(client: client, decoder: decoder)
            try await reviewService.createReview(
                branchId: branchId,
                barberId: barberId,
                appointmentId: appointmentId,
                rating: rating,
                comment: comment
            )
        }
        
        func fetchReviews(barberId: UUID) async throws -> [Review] {
            let reviewService = ReviewsService(client: client, decoder: decoder)
            return try await reviewService.fetchReviews(barberId: barberId)
        }
}
