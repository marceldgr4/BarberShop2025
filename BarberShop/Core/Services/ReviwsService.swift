//
//  ReviwsService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class ReviwsService{
    private let client: SupabaseClient
    private let decoder: JSONDecoder
    
    init(client: SupabaseClient, decoder: JSONDecoder) {
        self.client = client
        self.decoder = decoder
    }
    /// Crea una nueva reseña
    func createReview(
        branchId: UUID,
        barberId: UUID,
        appointmentId: UUID?,
        rating: Int,
        comment: String?
    ) async throws {
        let userId = try await client.auth.session.user.id
        let review = Review(
            id: UUID(),
            userId: userId,
            branchId: branchId,
            barberId: barberId,
            appointmentId: appointmentId,
            rating: rating,
            comment: comment,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await client
            .from("reviews")
            .insert(review)
            .execute()
    }
    
    /// Obtiene las reseñas de un barbero específico
    func fetchReviews(barberId: UUID) async throws -> [Review] {
        let response = try await client
            .from("reviews")
            .select()
            .eq("barber_id", value: barberId.uuidString)
            .order("created_at", ascending: false)
            .execute()
        
        return try decoder.decode([Review].self, from: response.data)
    }
}
