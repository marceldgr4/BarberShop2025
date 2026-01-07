//
//  ServiceService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class ServiceService{
    private let client: SupabaseClient
    private let decoder: JSONDecoder
    
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client, decoder: JSONDecoder = SupabaseManagerSecure.shared.decoder) {
        self.client = client
        self.decoder = decoder
    }
    /// Obtiene todos los servicios activos
    func fetchServices() async throws -> [Service] {
        let response = try await client
            .from("services")
            .select()
            .eq("is_active", value: true)
            .execute()
        
        return try decoder.decode([Service].self, from: response.data)
    }
    
    /// Obtiene todas las categorías de servicios
    func fecthServiceCategories() async throws -> [ServiceCategory] {
        let response = try await client
            .from("service_categories")
            .select()
            .execute()
        
        return try decoder.decode([ServiceCategory].self, from: response.data)
    }
}
