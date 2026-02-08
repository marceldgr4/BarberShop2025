//
//  AppointmentsViewModel+Extended.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/01/26.
//

import Foundation
import Combine
import UserNotifications

extension AppointmentViewModel {
    
    // MARK: - Filter Methods
    func applyFilter(_ filter: AppointmentFilter) async {
        selectedFilter = filter
        isLoading = true
        errorMessage = nil
        
        do {
            filteredAppointment = try await appointmentService.fetchFilteredAppointments(filter: filter)
            print("✅ Filtered appointment: \(filteredAppointment.count)")
        } catch {
            errorMessage = "Failed to filter appointment: \(error.localizedDescription)"
            print("❌ Filter error: \(error)")
        }
        isLoading = false
    }
    func cancelAppointment(
            _ appointmentId: UUID,
            reason: AppointmentDetail.CancellationReason,
            customReason: String? = nil
        ) async {
            isLoading = true
            errorMessage = nil
            
            do {
                try await appointmentService.cancelAppointment(
                    appointmentId: appointmentId,
                    reason: reason,
                    customReason: customReason
                )
                
                // Recargar citas después de cancelar
                await loadAppointments()
                
                print("✅ Appointment cancelled successfully")
            } catch {
                errorMessage = "Failed to cancel appointment: \(error.localizedDescription)"
                print("❌ Cancel error: \(error)")
            }
            
            isLoading = false
        }
        
        // MARK: - Reschedule Appointment
        func rescheduleAppointment(
            _ appointmentId: UUID,
            newDate: Date,
            newTime: String
        ) async {
            isLoading = true
            errorMessage = nil
            
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: newDate)
                
                try await appointmentService.rescheduleAppointment(
                    appointmentId: appointmentId,
                    newDate: dateString,
                    newTime: newTime
                )
                
                // Recargar citas después de reprogramar
                await loadAppointments()
                
                print("✅ Appointment rescheduled successfully")
            } catch {
                errorMessage = "Failed to reschedule appointment: \(error.localizedDescription)"
                print("❌ Reschedule error: \(error)")
            }
            
            isLoading = false
        }
        
        // MARK: - Get Appointment Details
        func fetchAppointmentDetails(_ appointmentId: UUID) async -> AppointmentDetail? {
            isLoading = true
            errorMessage = nil
            
            do {
                let detail = try await appointmentService.fetchAppointmentDetails(appointmentId: appointmentId)
                isLoading = false
                return detail
            } catch {
                errorMessage = "Failed to fetch appointment details: \(error.localizedDescription)"
                print("❌ Fetch details error: \(error)")
                isLoading = false
                return nil
            }
        }
}
