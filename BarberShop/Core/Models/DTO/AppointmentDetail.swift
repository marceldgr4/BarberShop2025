//
//  AppointmentDetail.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 12/12/25.
//

import Foundation
struct AppointmentDetail: Identifiable, Codable{
    let id:UUID
    let appointmentDate: String
    let appointmentTime: String
    let totalPrice: Double
    let notes: String?
    let statusName: String
    let barberName: String
    let barberPhoto: String
    let serviceName: String
    let branchName: String
    let branchAddress: String
    
    enum CodingKeys: String, CodingKey{
        case id, notes
               case appointmentDate = "appointment_date"
               case appointmentTime = "appointment_time"
               case totalPrice = "total_price"
               case statusName = "status_name"
               case barberName = "barber_name"
               case barberPhoto = "barber_photo"
               case serviceName = "service_name"
               case branchName = "branch_name"
               case branchAddress = "branch_address"
    }
}
