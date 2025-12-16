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
    @Published var appointments : [AppointmentDetail] = [ ]
    @Published var selectedBranch: Branch?
    @Published var selectedBarber: BarberWithRating?
    @Published var selectedService: Service?
    @Published var selectedDate = Date()
    @Published var selectedTime = "09:00"
    @Published var notes = " "
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccess = false
    
    private let supabase = SupabaseManager.shared
    
    func loadAppointments() async{
        isLoading = true
    
        do{
            appointments = try await supabase.fecthUserAppointments()
            
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func createAppointment() async {
        guard let branch = selectedBranch,
              let barber = selectedBarber,
              let service = selectedService else{
            errorMessage = "please select all required fileds"
            return
        }
        isLoading = true
        errorMessage = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yyyy"
        let dateString = formatter.string(from: selectedDate)
        
        do {
            _ = try await supabase.createAppointment(branchId: branch.id,
                                                     barberId: barber.id,
                                                     serviceId: service.id,
                                                     date: dateString,
                                                     time: selectedTime,
                                                     price: service.price,
                                                     notes: notes.isEmpty ? nil: notes
            )
            showSuccess = true
            resetSelection()
            await loadAppointments()
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    func resetSelection(){
        selectedBranch = nil
        selectedBarber = nil
        selectedService = nil
        selectedDate = Date()
        selectedTime = "09:00"
        notes = ""
    }
    
}
