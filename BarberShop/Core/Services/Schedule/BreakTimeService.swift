//
//  BreakTimeService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Supabase

extension ScheduleService{
    
    func fetchBreakTimes(barberId: UUID) async throws -> [BreakTime]{
        let response = try await client
            .from("break_times")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .execute()
        
        return try decoder.decode([BreakTime].self, from: response.data)
    }
    
    func fetchBreakTime(
        barberId: UUID,
        type: BreakTime.BreakType
    )
    async throws -> [BreakTime]{
        let allBreaks = try await fetchBreakTimes(barberId: barberId)
        return allBreaks.filter{$0.breakType == type}
    }
    
    func createBreakTime(
        barberId: UUID,
        breakType: BreakTime.BreakType,
        startTime: String,
        endTime: String,
        daysOfWeek:[Int]
    )
    async throws -> BreakTime{
        guard daysOfWeek.allSatisfy({(0...6).contains($0) }) else{
            throw ScheduleServiceError.invalidDaysOfWeek
        }
        let breakTime = BreakTime(
                    id: UUID(),
                    barberId: barberId,
                    breakType: breakType,
                    startTime: startTime,
                    endTime: endTime,
                    dayOfWeek: daysOfWeek
                )
                
                try await client
                    .from("break_times")
                    .insert(breakTime)
                    .execute()
                
                return breakTime
            }
            
            
            func updateBreakTime(
                breakId: UUID,
                startTime: String,
                endTime: String,
                daysOfWeek: [Int]
            ) async throws {
              
                guard daysOfWeek.allSatisfy({ (0...6).contains($0) }) else {
                    throw ScheduleServiceError.invalidDaysOfWeek
                }
                
                let update = BreakTimeUpdate(
                    startTime: startTime,
                    endTime: endTime,
                    daysOfWeek: daysOfWeek
                )
                
                try await client
                    .from("break_times")
                    .update(update)
                    .eq("id", value: breakId.uuidString)
                    .execute()
            }
            
            
            func deleteBreakTime(breakId: UUID) async throws {
                try await client
                    .from("break_times")
                    .delete()
                    .eq("id", value: breakId.uuidString)
                    .execute()
            }
            
            
            func isBarberOnBreak(
                barberId: UUID,
                dayOfWeek: Int,
                time: String
            ) async throws -> Bool {
                let breaks = try await fetchBreakTimes(barberId: barberId)
                return breaks.contains { breakTime in
                    breakTime.dayOfWeek.contains(dayOfWeek) &&
                    isTimeInRange(time, start: breakTime.startTime, end: breakTime.endTime)
                }
            }
        }
