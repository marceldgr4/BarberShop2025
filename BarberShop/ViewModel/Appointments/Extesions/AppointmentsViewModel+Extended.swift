//
//  AppointmentsViewModel+Extended.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/01/26.
//

import Foundation
import Combine
import UserNotifications

extension AppointmentViewModel{
    
    @Published var selectedFilter: AppointmentFilter = .all
    @Published var filteredAppointment: [AppointmentDetail] = []
    
    func applyFilter(_ filter: AppointmentFilter) async{
        selectedFilter = filter
        isLoading = true
        errorMessage = nil
        
        do{
            filteredAppointment = try await appointmentsService.fetchFilteredAppointments(filter: filter)
            print("filtered appointment: \(filteredAppointment.count)")
        } catch{
            errorMessage = "failed to filter appointment: \(error.localizedDescription)"
            print("filter error: \(error)")
        }
        isLoading = false
    }
}
