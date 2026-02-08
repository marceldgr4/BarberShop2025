//
//  AppointmentServiceExtended.swift
//  BarberShop
//
//  Created by Assistant on 19/01/26.
//

import Foundation
import Supabase

extension AppointmentService {
    
    // MARK: - Cancel Appointment
    func cancelAppointment(
        appointmentId: UUID,
        reason: CancellationReason,
        customReason: String? = nil
    ) async throws {
        // Obtener el estado "cancelled"
        let statusResponse = try await client
            .from("appointment_status")
            .select()
            .eq("status_name", value: "cancelled")
            .single()
            .execute()
        
        let statusData = try JSONSerialization.jsonObject(with: statusResponse.data) as? [String: Any]
        guard let cancelledStatusId = statusData?["id"] as? String else {
            throw NSError(domain: "Appointment", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Cancelled status not found"
            ])
        }
        
        // Usar estructura Encodable en lugar de diccionario
        struct AppointmentUpdate: Encodable {
            let status_id: String
            let updated_at: String
            let cancellation_reason: String
        }
        
        let update = AppointmentUpdate(
            status_id: cancelledStatusId,
            updated_at: ISO8601DateFormatter().string(from: Date()),
            cancellation_reason: customReason ?? reason.rawValue
        )
        
        try await client
            .from("appointments")
            .update(update)
            .eq("id", value: appointmentId.uuidString)
            .execute()
        
        print("Appointment cancelled successfully")
    }
    
    // MARK: - Reschedule Appointment
    func rescheduleAppointment(
        appointmentId: UUID,
        newDate: String,
        newTime: String
    ) async throws {
        let formattedTime = formatTime(newTime)
        
        struct AppointmentReschedule: Encodable {
            let appointment_date: String
            let appointment_time: String
            let updated_at: String
        }
        
        let update = AppointmentReschedule(
            appointment_date: newDate,
            appointment_time: formattedTime,
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
        
        try await client
            .from("appointments")
            .update(update)
            .eq("id", value: appointmentId.uuidString)
            .execute()
        
        print(" Appointment rescheduled to \(newDate) at \(formattedTime)")
    }
    
    // MARK: - Get Appointment Details
    func fetchAppointmentDetails(appointmentId: UUID) async throws -> AppointmentDetail {
        let response = try await client
            .from("appointments")
            .select("""
                id,
                appointment_date, 
                appointment_time,
                total_price, 
                notes,                    
                appointment_status!inner(status_name),
                barbers!inner(name, photo_url),
                services!inner(name),
                branches!inner(name, address)
            """)
            .eq("id", value: appointmentId.uuidString)
            .single()
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        
        guard let dict = json,
              let id = dict["id"] as? String,
              let date = dict["appointment_date"] as? String,
              let time = dict["appointment_time"] as? String,
              let price = dict["total_price"] as? Double,
              let status = dict["appointment_status"] as? [String: Any],
              let statusName = status["status_name"] as? String,
              let barber = dict["barbers"] as? [String: Any],
              let barberName = barber["name"] as? String,
              let service = dict["services"] as? [String: Any],
              let serviceName = service["name"] as? String,
              let branch = dict["branches"] as? [String: Any],
              let branchName = branch["name"] as? String,
              let branchAddress = branch["address"] as? String
        else {
            throw NSError(domain: "Appointment", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Invalid appointment data"
            ])
        }
        
        return AppointmentDetail(
            id: UUID(uuidString: id) ?? UUID(),
            appointmentDate: date,
            appointmentTime: time,
            totalPrice: price,
            notes: dict["notes"] as? String,
            statusName: statusName,
            barberName: barberName,
            barberPhoto: barber["photo_url"] as? String ?? "",
            serviceName: serviceName,
            branchName: branchName,
            branchAddress: branchAddress
        )
    }
    
    // MARK: - Filter Appointments
    func fetchFilteredAppointments(filter: AppointmentDetail.AppointmentFilter) async throws -> [AppointmentDetail] {
        let allAppointments = try await fecthUserAppointments()
        
        switch filter {
        case .all:
            return allAppointments
            
        case .upcoming:
            return allAppointments.filter { appointment in
                guard let date = appointment.appointmentDate.toDate() else { return false }
                return date >= Date() && ["pending", "confirmed"].contains(appointment.statusName.lowercased())
            }
            
        case .past:
            return allAppointments.filter { appointment in
                guard let date = appointment.appointmentDate.toDate() else { return false }
                return date < Date() || appointment.statusName.lowercased() == "completed"
            }
            
        case .cancelled:
            return allAppointments.filter { appointment in
                appointment.statusName.lowercased() == "cancelled"
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ time: String) -> String {
        // Asegurar formato HH:mm:ss
        let components = time.split(separator: ":")
        guard components.count >= 2 else { return "\(time):00:00" }
        
        if components.count == 2 {
            return "\(components[0]):\(components[1]):00"
        }
        return time
    }
}
