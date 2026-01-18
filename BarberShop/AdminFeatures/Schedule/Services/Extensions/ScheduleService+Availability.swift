//
//  AvailabilityOperationsService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Supabase

extension ScheduleService{
    
    func isBarberAvailable(
        barberId: UUID,
        date: String,
        time: String
    )
    async throws -> Bool{
        if try await isHoliday(date: date){
            return false
        }
        
        let overrides = try await fetchScheduleOverrides(barberId: barberId, date: date)
        if let override = overrides.first, !override.isAvailable{
            return false
        }
        
        guard let dateObj = date.toDate() else{
            return false
        }
        
        let dayOfWeek = dateObj.dayOfWeek
        let schedules = try await fetchBarberSchedule(barberId: barberId)
        
        guard let schedule = schedules.first(where: {$0.dayOfWeek == dayOfWeek && $0.isAvailable}) else{
            return false
        }
        
        guard let timeObj = time.toTime(),
              let startTime = schedule.startTime.toTime(),
              let endTime = schedule.endTime.toTime() else{
            return false
        }
        if timeObj < startTime || timeObj >= endTime{
            return false
        }
        
        if try await isBarberOnBreak(barberId: barberId, dayOfWeek: dayOfWeek, time: time){
            return false
        }
        
        // verification appoinment active
        let response = try await client
            .from("appointments")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .eq("appointment_date", value: date)
            .execute()
        
        let appointment = try  decoder.decode([Appointment].self, from: response.data)
        
        let hasAppointment = appointment.contains {appointment in
            isTimeInRange(time, start: appointment.appointmentTime,
                          end: appointment.appointmentTime)
        }
        return !hasAppointment
    }
    
    
    // MARK: - Helper Methods
    
    private func fetchExistingAppointments(
        barberId: UUID,
        date: String
    ) async throws -> [Appointment] {
        let response = try await client
            .from("appointments")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .eq("appointment_date", value: date)
            .execute()
        
        return try decoder.decode([Appointment].self, from: response.data)
    }
    
    
     func isHoliday(date: String) async throws -> Bool {
        let response = try await client
            .from("holidays")
            .select()
            .eq("date", value: date)
            .execute()
        
        let holidays = try decoder.decode([Holiday].self, from: response.data)
        return !holidays.isEmpty
    }
    
}
