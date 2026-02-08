//
//  AppointmentViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/12/25.
//

import Foundation
import Combine

@MainActor
class AppointmentViewModel: ObservableObject {
    // MARK: - Changed from private to internal so extensions can access
    internal let appointmentService = AppointmentService()
    
    // MARK: - Published Properties
    @Published var appointments: [AppointmentDetail] = []
    @Published var selectedBranch: Branch?
    @Published var selectedBarber: BarberWithRating?
    @Published var selectedService: Service?
    @Published var selectedDate = Date()
    @Published var selectedTime = "09:00"
    @Published var notes = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false
    
    // MARK: - Filter Properties (moved from extension)
    @Published var selectedFilter: AppointmentFilter = .all
    @Published var filteredAppointment: [AppointmentDetail] = []
    
    // MARK: - Load Appointments
    func loadAppointments() async {
        isLoading = true
        errorMessage = nil
        
        do {
            appointments = try await appointmentService.fecthUserAppointments()
            print("✅ Loaded \(appointments.count) appointments")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error loading appointments: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Create Appointment
    func createAppointment() async {
        guard let branch = selectedBranch,
              let barber = selectedBarber,
              let service = selectedService else {
            errorMessage = "Please select all required fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        
        do {
            _ = try await appointmentService.createAppointment(
                branchId: branch.id,
                barberId: barber.id,
                serviceId: service.id,
                date: dateString,
                time: selectedTime,
                price: service.price,
                notes: notes.isEmpty ? nil : notes
            )
            showSuccess = true
            resetSelection()
            await loadAppointments()
            print("✅ Appointment created successfully")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error creating appointment: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Reset Selection
    func resetSelection() {
        selectedBranch = nil
        selectedBarber = nil
        selectedService = nil
        selectedDate = Date()
        selectedTime = "09:00"
        notes = ""
    }
}
