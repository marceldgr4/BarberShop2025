//
//  BlockTimeService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Combine
extension ScheduleService{
    
    func generateTimeBlocks(
        barberId: UUID,
        date: String,
        slotDuration: Int = 30
    )
    async throws -> [TimeBlock]{
        guard let dateObj = date.toDate() else{
            throw ScheduleServiceError.invalidDateFormat
        }
        let dayOfWeek = dateObj.dayOfWeek
        
        let schedule = try await fetchDaySchedule(barberId: barberId,
                                                  dayOfWeek: dayOfWeek)
        guard let validSchedule = schedule else{
            return []
        }
        if try await isDayBlocked(barberId: barberId, date: date){
            return[]
        }
        async let breaks = fetchBreakTimes(barberId: barberId)
        async let appointments = fetchExistingAppointment(barberId: barberId, date: date)
        
        let (breakTime, existingAppointments) = try await ( breaks,appointments)
        
        return generateBlocks(
            schedule: validSchedule,
            breakTimes: breakTime,
            appointment: existingAppointments,
            dayOfWeek: dayOfWeek,
            date: date,
            barberId: barberId,
            slotDuration: slotDuration
        )
    }
    func fetchAvailableTimeBlocks(
        barberId: UUID,
        date: String
    )async throws -> [ TimeBlock]{
        let allBlocks = try await generateTimeBlocks(barberId: barberId, date: date)
        return allBlocks.filter{ $0.blockType == .available}
    }
    
    func generateTimeBlocksForRange(
        barberId: UUID,
        startDate: String,
        endDate: String,
        slotDuration: Int = 30
    ) async throws -> [String: [TimeBlock]]{
        guard let start = startDate.toDate(),
              let end = endDate.toDate() else{
            throw ScheduleServiceError.invalidDateRange
        }
        var allBlocks: [String: [TimeBlock]] = [:]
        var currentDate = start
        
        while currentDate <= end{
            let dateStr = currentDate.toString()
            let blocks = try await generateTimeBlocks(barberId: barberId, date: dateStr, slotDuration: slotDuration)
            allBlocks[dateStr] = blocks
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        return allBlocks
    }
}
