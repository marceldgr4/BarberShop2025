//
//  Navigation.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 27/12/25.
//

import Foundation

extension BookingViewModel {
    
    func nextStep() {
        guard canProceedToNextStep else { return}
        
        switch currentStep{
        
        case .selectBranch : currentStep = .selectBarber
            Task{
                await loadBarbers()
            }
        case .selectBarber:
            currentStep = .selectService
            Task{
                await loadService()
            }
        case .selectService:
            currentStep = .selectDateTime
            Task{
                await loadAvailableTimeSlots()
            }
        case .selectDateTime:
            currentStep = .confirmation
        case .confirmation:
            break
        }
    }
    func previosStep(){
        currentStep = BookingStep(rawValue: currentStep.rawValue - 1) ?? currentStep
    }
    
    func resetBooking(){
        currentStep = .selectBranch
        selectedBranch = nil
        selectedBarber = nil
        selectedService.removeAll()
        selectedDate = Date()
        selectedTime = nil
        notes = ""
        errorMessage = nil
        showSuccess = false
        bookingConfirmation = nil
    }
        
}
