//
//  BookingStep.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 27/12/25.
//

import Foundation

enum BookingStep: Int, CaseIterable{
    case selectBranch = 0
    case selectBarber = 1
    case selectService = 2
    case selectDateTime = 3
    case confirmation = 4
    
    var title: String{
        switch self {
        case . selectBranch: return "Select Branch"
        case .selectBarber: return "Select Barber"
        case .selectService: return "Select Service"
        case .selectDateTime : return "Select Date & Time"
        case .confirmation: return "Confirmation"
        }
    }
    var icon: String {
            switch self {
            case .selectBranch: return "building.2"
            case .selectBarber: return "person.fill"
            case .selectService: return "scissors"
            case .selectDateTime: return "calendar"
            case .confirmation: return "checkmark.circle"
            }
        }
    
}
