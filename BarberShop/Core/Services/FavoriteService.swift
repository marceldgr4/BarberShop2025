//
//  FavoriteService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class FavoriteService{
    private let client: SupabaseClient
    
    
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
       
    }
    /// Agrega o quita un barbero de favoritos
    func toggleFavoriteBarber(barberId: UUID) async throws {
        let userId = try await client.auth.session.user.id
        
        let response = try await client
            .from("favorite_barbers")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("barber_id", value: barberId.uuidString)
            .execute()
        
        if response.data.isEmpty {
            // Agregar a favoritos
            try await client
                .from("favorite_barbers")
                .insert([
                    "user_id": userId.uuidString,
                    "barber_id": barberId.uuidString
                ])
                .execute()
        } else {
            // Quitar de favoritos
            try await client
                .from("favorite_barbers")
                .delete()
                .eq("user_id", value: userId.uuidString)
                .eq("barber_id", value: barberId.uuidString)
                .execute()
        }
    }
    
    /// Obtiene los barberos favoritos del usuario
    func fetchFavoriteBarbers() async throws -> [BarberWithRating] {
        let userId = try await client.auth.session.user.id
        
        let response = try await client
            .from("favorite_barbers")
            .select("""
                barbers!inner(
                    id, 
                    branch_id, 
                    specialty_id, 
                    name, 
                    photo_url,                    
                    is_active,
                    barber_ratings(average_rating, total_reviews)
                )
            """)
            .eq("user_id", value: userId.uuidString)
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        return json.compactMap { dict -> BarberWithRating? in
            guard let barber = dict["barbers"] as? [String: Any],
                  let id = barber["id"] as? String,
                  let branchId = barber["branch_id"] as? String,
                  let name = barber["name"] as? String,
                  let isActive = barber["is_active"] as? Bool
            else { return nil }
            
            var rating: Double?
            var totalReviews: Int?
            
            if let ratings = barber["barber_ratings"] as? [String: Any] {
                rating = ratings["average_rating"] as? Double
                totalReviews = ratings["total_reviews"] as? Int
            }
            
            return BarberWithRating(
                id: UUID(uuidString: id) ?? UUID(),
                branchId: UUID(uuidString: branchId) ?? UUID(),
                specialtyId: (barber["specialty_id"] as? String).flatMap { UUID(uuidString: $0) },
                name: name,
                photoUrl: barber["photo_url"] as? String,
                isActive: isActive,
                rating: rating,
                totalReviews: totalReviews
            )
        }
    }
}
