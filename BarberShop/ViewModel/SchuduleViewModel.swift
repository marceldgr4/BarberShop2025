//
//  SchuduleViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Combine

@MainActor
class SchuduleViewModel: BaseViewModel {
    
    @Published var selectedBarber: BarberWithRating?
    @Published var selectedDate = Date()
    @Published var selectedWeek:  [Date] = []
    
    @Published var weklySchudele: [BarberSchedule] = [ ]
    @Published var timeBlock: [TimeBlock] = [ ]
    @Published var availableSlots: [TimeBlock] = [ ]
    
    @Published var holidays: [Holiday] = [ ]
    @Published var schuledeOverrides: [ScheduleOverride] = [ ]
    
    @Published var breakTimes: [BreakTime] = [ ]
    
    @Published var availabilitySummery: [AvailabilitySummary] = [ ]
    
    @Published var showAddBreak = false
    @Published var showAddOverride = false
    
    private let schuduleService = schuduleService()
    
}
