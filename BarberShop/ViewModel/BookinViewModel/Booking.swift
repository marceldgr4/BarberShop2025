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
              let service = selectedServices.first,
              let time = selectedTime else{
            errorMessage = "Complete all required fields"
            return
        }
        await load { [self] in
            let date = formattedDate(selectedDate)
            
            self.bookingConfirmation = try await self.appointmentService.createAppointment(branchId: branch.id,
                                                                                 barberId: barber.id,
                                                                                 serviceId: service.id,
                                                                                 date: date,
                                                                                 time: time,
                                                                                           price: self.totalPrice,
                                                                                           notes: notes.isEmpty ? nil : self.notes
            )
            showSuccess = true
        }
    }
    
    private func formattedDate(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
