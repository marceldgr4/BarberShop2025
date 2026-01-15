//
//  ScheduleServiceError.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
enum ScheduleServiceError: LocalizedError {
    case invalidDateFormat
    case invalidDateRange
    case invalidDaysOfWeek
    case scheduleNotFound
    case conflictingAppointment
    case barberNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .invalidDateFormat:
            return "El formato de fecha proporcionado no es válido"
        case .invalidDateRange:
            return "El rango de fechas proporcionado no es válido"
        case .invalidDaysOfWeek:
            return "Los días de la semana deben estar entre 0 (Domingo) y 6 (Sábado)"
        case .scheduleNotFound:
            return "No se encontró el horario especificado"
        case .conflictingAppointment:
            return "Ya existe una cita en ese horario"
        case .barberNotAvailable:
            return "El barbero no está disponible en el horario solicitado"
        }
    }
}
