//
//  AppointmentService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class AppointmentService{
    private let client: SupabaseClient
    
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    convenience init(){
        self.init(client: SupabaseManager.shared.client)
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
        
        try await client
            .from("appointments")
            .insert(appointment)
            .execute()
        
        return appointment
    }
    
    /// Obtiene las citas del usuario actual
    func fecthUserAppointments() async throws -> [AppointmentDetail] {
        let userId = try await client.auth.session.user.id
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
        
        return json.compactMap { dict -> AppointmentDetail? in
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
            else { return nil }
            
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
    }
   
}
