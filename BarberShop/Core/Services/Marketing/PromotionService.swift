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
    
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client, decoder: JSONDecoder = SupabaseManagerSecure.shared.decoder) {
        self.client = client
        self.decoder = decoder
    }
    /// Obtiene las promociones activas vigentes hoy
    func fetchActivePromotions() async throws -> [Promotion] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX") // ✅ Locale fijo
        formatter.timeZone = TimeZone(identifier: "UTC")      // ✅ Timezone consistente
        let todayString = formatter.string(from: Date())
        
        print("🔍 Fetching promotions for date: \(todayString)")
        
        let response = try await client
            .from("promotions")
            .select()
            .eq("is_active", value: true)
            .execute() // ✅ Quitar filtros de fecha temporalmente para diagnosticar
        
        let promotions = try decoder.decode([Promotion].self, from: response.data)
        print("✅ Total promotions fetched: \(promotions.count)")
        
        // Filtrar en Swift mientras diagnosticas
        let filtered = promotions.filter { promotion in
            promotion.startDate <= todayString && promotion.endDate >= todayString
        }
        print("✅ Active promotions after filter: \(filtered.count)")
        
        return filtered
    }
}
