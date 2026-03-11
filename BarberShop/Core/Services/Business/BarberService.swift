//
//  BarberService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class BarberService {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManagerSecure.shared.client) {
        self.client = client
    }
    /// Obtiene barberos con su calificación
    func fetchBarbers(branchId: UUID? = nil) async throws -> [BarberWithRating] {
        var query =
            client
            .from("barbers")
            .select(
                """
                    id, 
                    branch_id, 
                    specialty,
                    full_name, 
                    photo_url,
                    is_active,
                    barber_stats!inner(average_rating, total_reviews)
                """
            )
            .eq("is_active", value: true)

        if let branchId = branchId {
            query = query.eq("branch_id", value: branchId.uuidString)
        }

        let response = try await query.execute()
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []

        return json.compactMap { dict -> BarberWithRating? in
            guard let id = dict["id"] as? String,
                let branchId = dict["branch_id"] as? String,
                let name = dict["full_name"] as? String,
                let isActive = dict["is_active"] as? Bool,
                let ratings = dict["barber_stats"] as? [String: Any],
                let avgRating = ratings["average_rating"] as? Double,
                let totalReviews = ratings["total_reviews"] as? Int
            else { return nil }

            return BarberWithRating(
                id: UUID(uuidString: id) ?? UUID(),
                branchId: UUID(uuidString: branchId) ?? UUID(),
                name: name,
                photoUrl: dict["photo_url"] as? String,
                specialty: dict["specialty"] as? String,
                isActive: isActive,
                rating: avgRating,
                totalReviews: totalReviews
            )
        }
    }
}
