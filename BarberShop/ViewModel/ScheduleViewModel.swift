//
//  ScheduleViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Combine

// MARK: - AdminFeatures Schedule Models
//import AdminFeatures.Schedule.Models
//import AdminFeatures.Schedule.Services

@MainActor
class ScheduleViewModel: BaseViewModel {
    
    @Published var selectedBarber: BarberWithRating?
    @Published var selectedDate = Date()
    @Published var selectedWeek:  [Date] = []
    
    @Published var weeklySchedule: [BarberSchedule] = [ ]
    @Published var timeBlocks: [TimeBlock] = [ ]
    @Published var availableSlots: [TimeBlock] = [ ]
    
    @Published var holidays: [Holiday] = [ ]
    @Published var scheduleOverrides: [ScheduleOverride] = [ ]
    
    @Published var breakTimes: [BreakTime] = [ ]
    
    @Published var availabilitySummery: [AvailabilitySummary] = [ ]
    
    @Published var showAddBreak = false
    @Published var showAddOverride = false
    
    var isDateBlocked: Bool {
            guard let barber = selectedBarber else { return false }
            let dateStr = selectedDate.toString()
            
            // Verificar si hay un override que bloquea este día
            return scheduleOverrides.contains { override in
                override.barberId == barber.id &&
                override.date == dateStr &&
                !override.isAvailable
            }
        }
        
        // MARK: - Services
        private let scheduleService = ScheduleService()
        
        // MARK: - Initialization
        override init() {
            super.init()
            updateSelectedWeek()
        }
        
        // MARK: - Barber Selection
        func selectedBarber(_ barber: BarberWithRating) {
            selectedBarber = barber
            Task {
                await loadBarberSchedule()
            }
        }
        
        // MARK: - Week Navigation
        func moveToPreviousWeek() {
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
            updateSelectedWeek()
            Task {
                await loadTimeBlocks()
            }
        }
        
        func moveToNextWeek() {
            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
            updateSelectedWeek()
            Task {
                await loadTimeBlocks()
            }
        }
        
        private func updateSelectedWeek() {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: selectedDate)
            let daysToSubtract = (weekday == 1) ? 6 : weekday - 2 // Lunes como primer día
            
            guard let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: selectedDate) else {
                return
            }
            
            selectedWeek = (0..<7).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
            }
        }
        
        // MARK: - Data Loading
        func loadBarberSchedule() async {
            guard let barber = selectedBarber else { return }
            
            await execute {
                async let scheduleTask = self.scheduleService.fetchBarberSchedule(barberId: barber.id)
                async let breaksTask = self.scheduleService.fetchBreakTimes(barberId: barber.id)
                async let overridesTask = self.scheduleService.fetchAllScheduleOverrides(barberId: barber.id)
                
                self.weeklySchedule = try await scheduleTask
                self.breakTimes = try await breaksTask
                self.scheduleOverrides = try await overridesTask
                
                await self.loadTimeBlocks()
            }
        }
        
        func loadTimeBlocks() async {
            guard let barber = selectedBarber else { return }
            
            await execute {
                let dateStr = self.selectedDate.toString()
                self.timeBlocks = try await self.scheduleService.generateTimeBlocks(
                    barberId: barber.id,
                    date: dateStr
                )
                self.availableSlots = self.timeBlocks.filter { $0.blockType == .available }
            }
        }
        
        // MARK: - Break Management
        func addBreakTime(
            type: BreakTime.BreakType,
            startTime: String,
            endTime: String,
            daysOfWeek: [Int]
        ) async {
            guard let barber = selectedBarber else { return }
            
            await execute {
                _ = try await self.scheduleService.createBreakTime(
                    barberId: barber.id,
                    breakType: type,
                    startTime: startTime,
                    endTime: endTime,
                    daysOfWeek: daysOfWeek
                )
                await self.loadBarberSchedule()
            }
        }
        
        func deleteBreakTime(_ breakId: UUID) async {
            await execute {
                try await self.scheduleService.deleteBreakTime(breakId: breakId)
                await self.loadBarberSchedule()
            }
        }
        
        // MARK: - Override Management (Bloqueo de Días)
        func blockDay(
            date: String,
            reason: ScheduleOverride.OverrideReason,
            customReason: String? = nil
        ) async {
            guard let barber = selectedBarber else { return }
            
            await execute {
                _ = try await self.scheduleService.createScheduleOverride(
                    barberId: barber.id,
                    date: date,
                    reason: reason,
                    customReason: customReason,
                    isAvailable: false // ✅ Día bloqueado
                )
                await self.loadBarberSchedule()
            }
        }
        
        func unblockDay(_ overrideId: UUID) async {
            await execute {
                try await self.scheduleService.deleteScheduleOverride(overrideId: overrideId)
                await self.loadBarberSchedule()
            }
        }
        
        // MARK: - Schedule Update
        func updateSchedule(
            scheduleId: UUID,
            startTime: String,
            endTime: String,
            isAvailable: Bool
        ) async {
            await execute {
                try await self.scheduleService.updateBarberSchedule(
                    scheduleId: scheduleId,
                    startTime: startTime,
                    endTime: endTime,
                    isAvailable: isAvailable
                )
                await self.loadBarberSchedule()
            }
        }
    }
