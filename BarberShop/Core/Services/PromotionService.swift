//
//  PromotionService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase
final class PromotionService{
    private let client: SupabaseClient
    private let decoder: JSONDecoder
    
    init(client: SupabaseClient = SupabaseManager.shared.client, decoder: JSONDecoder = SupabaseManager.shared.decoder) {
        self.client = client
        self.decoder = decoder
    }
    /// Obtiene las promociones activas vigentes hoy
    func fetchActivePromotions() async throws -> [Promotion] {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        let response = try await client
            .from("promotions")
            .select()
            .eq("is_active", value: true)
            .lte("start_date", value: todayString)
            .gte("end_date", value: todayString)
            .execute()
        
        return try decoder.decode([Promotion].self, from: response.data)
    }
}
