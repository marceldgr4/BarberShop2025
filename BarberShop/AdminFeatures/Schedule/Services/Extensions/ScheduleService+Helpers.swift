//
//  ExetensionHelper.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Combine
import Supabase

extension Date{
    var dayOfWeek: Int{
        let calendra = Calendar.current
        let weekday = calendra.component(.weekday, from: self)
        return weekday - 1
    }
}


extension ScheduleService{
    
    func fetchDaySchedule(
        barberId: UUID,
        dayOfWeek: Int
        
    ) async throws -> BarberSchedule?{
        let schedules =  try await fetchBarberSchedule(barberId: barberId)
        return schedules.first{ $0.dayOfWeek == dayOfWeek && $0.isAvailable }
    }
    
    func isDayBlocked(
            barberId: UUID,
            date: String
        ) async throws -> Bool {
            // Verificar feriados
            if try await isHoliday(date: date) {
                return true
            }
            
            // Verificar overrides
            let overrides = try await fetchScheduleOverrides(barberId: barberId, date: date)
            return overrides.contains { !$0.isAvailable }
        }
    
    func generateBlocks(
            schedule: BarberSchedule,
            breakTimes: [BreakTime],
            appointment: [Appointment],
            dayOfWeek: Int,
            date: String,
            barberId: UUID,
            slotDuration: Int
        ) -> [TimeBlock] {
            var blocks: [TimeBlock] = []
            
            guard let startTime = schedule.startTime.toTime(),
                  let endTime = schedule.endTime.toTime() else {
                return blocks
            }
            
            let calendar = Calendar.current
            var currentTime = startTime
            
            while currentTime < endTime {
                let currentTimeStr = currentTime.toTimeString()
                
                // Determinar el tipo de bloque
                let blockType = determineBlockType(
                    time: currentTimeStr,
                    breakTimes: breakTimes,
                    appointments: appointment,
                    dayOfWeek: dayOfWeek
                )
                
                // Buscar si hay una cita en este horario
                let appointmentId = appointment.first {
                    $0.appointmentTime == currentTimeStr
                }?.id
                
                let block = TimeBlock(
                    id: UUID(),
                    barberId: barberId,
                    date: date,
                    startTime: currentTimeStr,
                    endTime: calendar.date(byAdding: .minute, value: slotDuration, to: currentTime)?.toTimeString() ?? currentTimeStr,
                    isBooked: blockType == .booked,
                    appointmentId: appointmentId,
                    blockType: blockType
                )
                
                blocks.append(block)
                
                // Avanzar al siguiente slot
                currentTime = calendar.date(byAdding: .minute, value: slotDuration, to: currentTime) ?? currentTime
            }
            
            return blocks
        }
    
    private func determineBlockType(
            time: String,
            breakTimes: [BreakTime],
            appointments: [Appointment],
            dayOfWeek: Int
        ) -> TimeBlock.BlockType {
            // Verificar si es un break
            let isBreak = breakTimes.contains { breakTime in
                breakTime.dayOfWeek.contains(dayOfWeek) &&
                isTimeInRange(time, start: breakTime.startTime, end: breakTime.endTime)
            }
            
            if isBreak {
                return .break
            }
            
            // Verificar si está reservado
            let isBooked = appointments.contains { appointment in
                isTimeInRange(time, start: appointment.appointmentTime, end: appointment.appointmentTime)
            }
            
            if isBooked {
                return .booked
            }
            
            return .available
        }
    
     
    
    
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
