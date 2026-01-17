//
//  BranchService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class BranchService{
    private let client: SupabaseClient
    private let decoder: JSONDecoder
    
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client, decoder: JSONDecoder = SupabaseManagerSecure.shared.decoder) {
        self.client = client
        self.decoder = decoder
    }
    /// Obtiene todas las sucursales activas
    func fetchBranches() async throws -> [Branch] {
        let response = try await client
            .from("branches")
            .select()
            .eq("is_active", value: true)
            .execute()
        
        return try decoder.decode([Branch].self, from: response.data)
    }
    
    /// Obtiene el horario de una sucursal específica
    func fetchBranchHours(branchId: UUID) async throws -> [BranchHours] {
        let response = try await client
            .from("branch_hours")
            .select()
            .eq("branch_id", value: branchId.uuidString)
            .execute()
        
        return try decoder.decode([BranchHours].self, from: response.data)
    }
}
