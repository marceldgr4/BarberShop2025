//
//  ExetensionHelper.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Combine
import Supabase

extension ScheduleService{
    
    func fetchExistingAppointment(
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
    
    func isTimeInRange(_ time: String, start: String, end: String)-> Bool{
        guard let timeDate = time.toTime(),
              let startDate = start.toTime(),
              let endDate = end.toTime() else {
            return false
        }
        return timeDate >= startDate && timeDate < endDate
    }
}
