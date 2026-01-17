//
//  BarberScheduleService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Supabase
import Combine

extension ScheduleService{
   
    func fetchBarberSchedule(barberId: UUID) async throws -> [BarberSchedule]{
        let responde = try await client
            .from("barber_schedule")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .order("day_of_week")
            .execute()
        
        return try decoder.decode([BarberSchedule].self, from: responde.data)
    }
    func createBarberSchedule(
        barberId: UUID,
        schedule:[WeekSchedule]
        
    ) async throws{
        let newSchedules = schedule.map { schedule in
            BarberSchedule(
                id: UUID(),
                barberId: barberId,
                dayOfWeek: schedule.dayOfWeek,
                startTime: schedule.startTime,
                endTime: schedule.endTime,
                isAvailable: schedule.isAvailable,
                createdAt: Date(),
                updatedAt: Date()
              
            )
        }
        
        try await client
            .from("barber_schedules")
            .insert(newSchedules)
            .execute()
    }
    
    func updateBarberSchedule(
        scheduleId: UUID,
        startTime: String,
        endTime: String,
        isAvailable: Bool
        
    ) async throws {
        
        let update = ScheduleUpdate(
            startTime: startTime,
            endTime: endTime,
            isAvailable: isAvailable,
            updatedAt: Date().ISO8601Format()
        )
                
        try await client
            .from("barber_schedule")
            .insert(update)
            .eq("id", value: scheduleId.uuidString)
            .execute()
        
    }
    
    func deleteBarberSchedule( scheduleId: UUID) async throws{
        try await client
            .from("barber_schedules")
            .delete()
            .eq("id", value: scheduleId.uuidString)
            .execute()
    }
}
