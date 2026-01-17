//
//  Appointment.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation

struct Appointment: Identifiable, Codable{
    let id: UUID
    let userId: UUID
    let branchId: UUID
    let barberId: UUID
    let serviceId: UUID
    let statusId: UUID
    let appointmentDate: String
    let appointmentTime: String
    let totalPrice: Double
    let notes:String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id, notes
        case userId = "user_id"
        case branchId = "branch_id"
        case barberId = "barber_id"
        case serviceId = "service_id"
        case statusId = "status_id"
        case appointmentDate = "appointment_date"
        case appointmentTime = "appointment_time"
        case totalPrice = "total_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}



struct AppointmentStatus: Identifiable, Codable, Hashable{
    let id: UUID
    let statusName: String
    let description: String?
    
    enum CodingKeys: String, CodingKey{
        case id, description
        case statusName = "status_name"
    }
}
