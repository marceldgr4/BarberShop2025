//
//  BookingViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 27/12/25.
//

import Foundation
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    
    @Published var currentStep: BookingStep = .selectBranch
    @Published var selectedBranch: Branch?
    @Published var selectedBarber: BarberWithRating?
    @Published var selectedServices: [Service] = []
    @Published var selectedDate = Date()
    @Published var selectedTime: String?
    @Published var notes = ""
    
    @Published var branches: [Branch] = []
    @Published var barbers: [BarberWithRating] = []
    @Published var services: [Service] = []
    @Published var availableTimeSlots: [String] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false
    @Published var bookingConfirmation: Appointment?
    
    internal let branchService: BranchService
    internal let barberService: BarberService
    internal let serviceService: ServiceService
    internal let appointmentService: AppointmentService
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.branchService = BranchService(
            client: SupabaseManager.shared.client,
            decoder: SupabaseManager.shared.decoder
        )
        self.barberService = BarberService(
            client: SupabaseManager.shared.client
        )
        self.serviceService = ServiceService(
            client: SupabaseManager.shared.client,
            decoder: SupabaseManager.shared.decoder
        )
        self.appointmentService = AppointmentService(
            client: SupabaseManager.shared.client
        )
        
        Task {
            await loadBranches()
        }
    }
}
