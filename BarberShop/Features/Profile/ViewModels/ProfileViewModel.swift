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

    // MARK: - Estado publicado
    @Published var user: Profile?
    @Published var appointments: [AppointmentDetail] = []
    @Published var favoriteBarbers: [BarberWithRating] = []
    @Published var isLoading       = false
    @Published var isSaving        = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    // MARK: - Servicios
    // ✅ Reutiliza la instancia compartida para que currentProfile
    //    de AuthenticationService y este ViewModel estén sincronizados
    private let authService        = AuthenticationService.shared
    private let appointmentService = AppointmentService()
    private let favoriteService    = FavoriteService()

    // MARK: - Suscripción a cambios externos de currentProfile
    private var cancellables = Set<AnyCancellable>()

    init() {
        // ✅ Cada vez que AuthenticationService.currentProfile cambie
        //    (por cualquier motivo: update, refresh, etc.) se refleja aquí
        authService.$currentProfile
            .receive(on: DispatchQueue.main)
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Carga inicial
    func loadProfile() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let appointmentsTask = appointmentService.fetchUserAppointments()
            async let favoritesTask    = favoriteService.fetchFavoriteBarbers()

            // El perfil ya viene de currentProfile vía el sink de arriba,
            // pero hacemos fetch explícito para garantizar datos frescos
            try await authService.fetchCurrentProfile()
            appointments    = try await appointmentsTask
            favoriteBarbers = try await favoritesTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - ✅ Actualizar perfil (usa el método existente de AuthenticationService)
    func updateProfile(fullName: String, phone: String, avatarUrl: String? = nil) async {
        guard let userId = authService.currentProfile?.id else {
            errorMessage = "No hay sesión activa"
            return
        }

        isSaving       = true
        errorMessage   = nil
        successMessage = nil
        defer { isSaving = false }

        do {
            // updateProfile ya llama fetchCurrentProfile() internamente,
            // que actualiza authService.currentProfile,
            // que el sink de arriba propaga a self.user automáticamente ✅
            try await authService.updateProfile(
                userId:    userId,
                fullName:  fullName,
                phone:     phone,
                avatarUrl: avatarUrl
            )
            successMessage = "Perfil actualizado correctamente"
        } catch {
            errorMessage = "Error al actualizar: \(error.localizedDescription)"
        }
    }

    // MARK: - Toggle favorito
    func toggleFavorite(barberId: UUID) async {
        do {
            try await favoriteService.toggleFavoriteBarber(barberId: barberId)
            await loadProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
