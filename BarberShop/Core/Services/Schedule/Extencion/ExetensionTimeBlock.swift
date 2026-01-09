//
//  ExetensionTimeBlock.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation

 extension ScheduleService{
    
    func fetchDaySchedule(barberId: UUID, dayOfWeek: Int) async throws -> BarberSchedule?{
        let schedule = try await fetchBarberSchedule(barberId: barberId)
        return schedule.first { $0.dayOfWeek == dayOfWeek && $0.isAvailable}
    }
    func isDayBlocked( barberId: UUID, date: String) async throws -> Bool{
        let overrides = try await fetchScheduleOverrides(barberId: barberId, date: date)
        return overrides.first?.isAvailable == false
    }
    
    func generateBlocks(
        schedule: BarberSchedule,
        breakTimes: [BreakTime],
        appointment: [Appointment],
        dayOfWeek: Int,
        date: String,
        barberId: UUID,
        slotDuration: Int
        
    )-> [TimeBlock] {
        var blocks: [TimeBlock] = [ ]
        
        guard var currentTime = schedule.starTime.toTime(),
              let endTime = schedule.endTime.toTime() else{
            return [ ]
        }
        while currentTime < endTime{
            guard let nextTime = Calendar.current.date(byAdding: .minute,
                                                       value: slotDuration,
                                                       to: currentTime,
            ) else {break}
            let startTimeStr = currentTime.toTimeString()
            let endTimeStr = nextTime.toTimeString()
            
            let blockType = determineBlockType(
                startTime: startTimeStr,
                breaks: breakTimes,
                appointments: appointment,
                dayOfWeek: dayOfWeek
            )
            let appointment = appointment.first { apt in isTimeInRange(startTimeStr, start: apt.appointmentTime, end: apt.appointmentTime)
            }
            let block = TimeBlock(
                id: UUID(),
                barberId: barberId,
                date: date,
                starTime: startTimeStr,
                endTime: endTimeStr,
                isBooked: appointment != nil,
                appointmentId: appointment?.id,
                blockType: blockType
            )
            blocks.append(block)
            currentTime = nextTime
        }
        return blocks
    }
        
        func determineBlockType(
            startTime: String,
            breaks: [BreakTime],
            appointments: [Appointment],
            dayOfWeek: Int,
        ) -> TimeBlock.BlockType{
            let isBreak = breaks.contains{ BreakTime in BreakTime.dayOfWeek.contains(dayOfWeek) &&
                isTimeInRange(startTime, start: BreakTime.startTime, end: BreakTime.endTime)
            }
            if isBreak{
                return .break
            }
            let hasAppointment = appointments.contains{ apt in isTimeInRange( startTime,
                                                                              start: apt.appointmentTime, end: apt.appointmentTime)
            }
            return hasAppointment ? .booked: .available
        
    }
}
