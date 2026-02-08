//
//  AppointmentService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class AppointmentService{
    internal let client: SupabaseClient
    
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client) {
        self.client = client
    }
    convenience init(){
        self.init(client: SupabaseManagerSecure.shared.client)
    }
    /// Crea una nueva cita
    func createAppointment(
        branchId: UUID,
        barberId: UUID,
        serviceId: UUID,
        date: String,
        time: String,
        price: Double,
        notes: String?
    ) async throws -> Appointment {
        let userId = try await client.auth.session.user.id
        let statusResponse = try await client
            .from("appointment_status")
            .select()
            .eq("status_name", value: "pending")
            .single()
            .execute()
        
        let statusData = try JSONSerialization.jsonObject(with: statusResponse.data) as? [String: Any]
        guard let statusId = statusData?["id"] as? String else {
            throw NSError(domain: "Appointment", code: 1, userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }
        
        let formattedTime = time.contains(":") ? (time.count == 5 ? "\(time):00": time):"\(time):00:00"
        let appointment = Appointment(
            id: UUID(),
            userId: userId,
            branchId: branchId,
            barberId: barberId,
            serviceId: serviceId,
            statusId: UUID(uuidString: statusId)!,
            appointmentDate: date,
            appointmentTime: time,
            totalPrice: price,
            notes: notes,
            createdAt: Date(),
            updatedAt: Date()
        )
        print(" Creating appointment:")
        print("   Date: \(date)")
        print("   Time: \(formattedTime)")
        print("   Branch: \(branchId)")
        print("   Barber: \(barberId)")
        print("   Service: \(serviceId)")
        
        try await client
            .from("appointments")
            .insert(appointment)
            .execute()
        
        print("Appointment created successfully")
        
        return appointment
    }
    
    /// Obtiene las citas del usuario actual
    func fecthUserAppointments() async throws -> [AppointmentDetail] {
        let userId = try await client.auth.session.user.id
        
        print("Fetching appointments for user: \(userId)")
        
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
            .eq("user_id", value: userId.uuidString)
            .order("appointment_date", ascending: false)
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        print("Found \(json.count) appointments")
        
        let appointments = json.compactMap { dict -> AppointmentDetail? in
            guard let id = dict["id"] as? String,
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
                print("Fail to parse appointment: \(dict)")
                return nil }
            
            return AppointmentDetail(
                id: UUID(uuidString: id) ?? UUID(),
                appointmentDate: date,
                appointmentTime: time,
                totalPrice: price,
                notes: dict["notes"] as? String,
                statusName: statusName,
                barberName: barberName,
                barberPhoto: (barber["photo_url"] as? String) ?? "",
                serviceName: serviceName,
                branchName: branchName,
                branchAddress: branchAddress
            )
        }
        
        print("Successfully parsed \(appointments.count) appointments")
        return appointments
    }
    
    ///cancelar cita
    func cancelAppointment(appointmentId: UUID) async throws{
        let cancelledStatusId = try await getCancelledStatusId()
        
        try await client
            .from("appointments")
            .update(["status_id": cancelledStatusId.uuidString, "update_at": Date().ISO8601Format()])
            .eq("id", value: appointmentId.uuidString)
            .execute()
    }
    private func getCancelledStatusId() async throws -> UUID {
        let response = try await client
            .from("appointment_status")
            .select()
            .eq("status_name", value: "cancelled")
            .single()
            .execute()
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        guard let statusId = json?["id"] as? String else {
            throw NSError(domain: "Appointment", code: 1, userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }
        return UUID(uuidString: statusId)!
    }
    
    func fecthAppointmentByStatus(status: String) async throws -> [AppointmentDetail] {
        let userId = try await client.auth.session.user.id
        
        let response = try await client
            .from("appointments")
            .select("""
                id, appointment_date, appointment_time, total_price, notes,
                            appointment_status!inner(status_name),
                            barbers!inner(name, photo_url),
                            services!inner(name),
                            branches!inner(name, address)
                """)
            .eq("users_id", value: userId.uuidString)
            .eq("appointment_status_name", value: status)
            .order("appointment_date",ascending: false)
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        let appointments = json.compactMap { dict -> AppointmentDetail? in
            guard let id = dict["id"] as? String,
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
                return nil
            }
            
            return AppointmentDetail(
                id: UUID(uuidString: id) ?? UUID(),
                appointmentDate: date,
                appointmentTime: time,
                totalPrice: price,
                notes: dict["notes"] as? String,
                statusName: statusName,
                barberName: barberName,
                barberPhoto: (barber["photo_url"] as? String) ?? "",
                serviceName: serviceName,
                branchName: branchName,
                branchAddress: branchAddress
            )
        }
        
        return appointments
    }
}
    
   

