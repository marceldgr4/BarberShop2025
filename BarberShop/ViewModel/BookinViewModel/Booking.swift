//
//  Booking.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import Foundation
extension BookingViewModel{
    
    func createBooking() async{
        guard let branch = selectedBranch,
              let barber = selectedBarber,
              //let service = selectedServices.first,
              !selectedServices.isEmpty,
                let time = selectedTime else{
            errorMessage = "Please complete all required fields"
            return
        }
        isLoading = true
        errorMessage = nil
        
        do{
            let date = formattedDate(selectedDate)
            let service = selectedServices[0]
            
            bookingConfirmation = try await appointmentService.createAppointment(
                branchId: branch.id,
                barberId: barber.id,
                serviceId: service.id,
                date: date,
                time: time,
                price: totalPrice,
                notes: notes.isEmpty ? nil : notes
            )
            showSuccess = true
            print("booking created successfullu: \(bookingConfirmation?.id ?? UUID())")
        } catch{
            errorMessage = "Fail to create booking: \(error.localizedDescription)"
            print("booking error: \(error)")
        }
        isLoading = false
    }
    
    private func formattedDate(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
