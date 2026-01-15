//
//  ScheduleOverrideService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 9/01/26.
//

import Foundation
import Supabase

// MARK: - Schedule Override Operations
extension ScheduleService {
    
    /// Obtiene las anulaciones de horario para una fecha específica
    func fetchScheduleOverrides(
        barberId: UUID,
        date: String
    ) async throws -> [ScheduleOverride] {
        let response = try await client
            .from("schedule_overrides")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .eq("date", value: date)
            .execute()
        
        return try decoder.decode([ScheduleOverride].self, from: response.data)
    }
    
    /// Obtiene todas las anulaciones de un barbero
    func fetchAllScheduleOverrides(barberId: UUID) async throws -> [ScheduleOverride] {
        let response = try await client
            .from("schedule_overrides")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .order("date", ascending: false)
            .execute()
        
        return try decoder.decode([ScheduleOverride].self, from: response.data)
    }
    
    /// Obtiene anulaciones futuras
    func fetchFutureOverrides(barberId: UUID) async throws -> [ScheduleOverride] {
        let today = Date().toString()
        
        let response = try await client
            .from("schedule_overrides")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .gte("date", value: today)
            .order("date")
            .execute()
        
        return try decoder.decode([ScheduleOverride].self, from: response.data)
    }
    
    /// Crea una anulación de horario (día bloqueado)
    func createScheduleOverride(
        barberId: UUID,
        date: String,
        reason: ScheduleOverride.OverrideReason,
        customReason: String? = nil,
        isAvailable: Bool = false
    ) async throws -> ScheduleOverride {
        let override = ScheduleOverride(
            id: UUID(),
            barberId: barberId,
            date: date,
            reason: reason,
            customReason: customReason,
            isAvailable: isAvailable,
            startTime: nil,
            endTime: nil,
            createdAt: Date()
        )
        
        try await client
            .from("schedule_overrides")
            .insert(override)
            .execute()
        
        return override
    }
    
    /// Crea una anulación con horario personalizado
    func createScheduleOverrideWithCustomTime(
        barberId: UUID,
        date: String,
        startTime: String,
        endTime: String,
        reason: ScheduleOverride.OverrideReason,
        customReason: String? = nil
    ) async throws -> ScheduleOverride {
        let override = ScheduleOverride(
            id: UUID(),
            barberId: barberId,
            date: date,
            reason: reason,
            customReason: customReason,
            isAvailable: true,
            startTime: startTime,
            endTime: endTime,
            createdAt: Date()
        )
        
        try await client
            .from("schedule_overrides")
            .insert(override)
            .execute()
        
        return override
    }
    
    /// Actualiza una anulación de horario
    func updateScheduleOverride(
        overrideId: UUID,
        isAvailable: Bool,
        startTime: String? = nil,
        endTime: String? = nil
    ) async throws {
        let update = ScheduleOverrideUpdate(
            isAvailable: isAvailable,
            startTime: startTime,
            endTime: endTime
        )
        
        try await client
            .from("schedule_overrides")
            .update(update)
            .eq("id", value: overrideId.uuidString)
            .execute()
    }
    
    /// Elimina una anulación de horario
    func deleteScheduleOverride(overrideId: UUID) async throws {
        try await client
            .from("schedule_overrides")
            .delete()
            .eq("id", value: overrideId.uuidString)
            .execute()
    }
}
