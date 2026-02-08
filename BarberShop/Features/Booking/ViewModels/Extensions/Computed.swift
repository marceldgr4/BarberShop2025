//
//  Computed.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 29/12/25.
//

import Foundation

extension BookingViewModel{
    
    var totalPrice : Double{
        selectedServices.reduce(0) {
            $0 + $1.price
        }
    }
    var totalDuration: Int{
        selectedServices.reduce(0) {$0 + $1.durationMinutes}
    }
    var canProceedToNextStep: Bool{
        switch currentStep {
        case .selectBranch:
            return selectedBranch != nil
        case .selectBarber:
            return selectedBarber != nil
        case .selectService:
            return !selectedServices.isEmpty
        case .selectDateTime:
            return selectedTime != nil
        case .confirmation:
            return true
        }
    }
    func toogleService(_ service: Service){
        if selectedServices.contains(where: {$0.id == service.id}){
            selectedServices.removeAll{$0.id == service.id}
        }else{
            selectedServices.append(service)
        }
    }
    
    func isServiceSelected(_ service: Service) -> Bool{
        selectedServices.contains{$0.id == service.id}
    }
}
