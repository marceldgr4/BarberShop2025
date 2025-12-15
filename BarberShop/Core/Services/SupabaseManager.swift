//
//  SupabaseManager.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//

import Combine
import Foundation
import Supabase
import SwiftUI

final class SupabaseManager {
    static let shared = SupabaseManager()

    private let supabaseUrl: URL = URL(string: "https://vxcaadneaegpuqhtgkhz.supabase.co")!
    private let supabaseKey: String =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4Y2FhZG5lYWVncHVxaHRna2h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1MjA1MjYsImV4cCI6MjA3OTA5NjUyNn0.5oYbrcyYSQTcEiDi0zR6Umr5ZGKbjOFu-GsQs0SwcP0"

    let client: SupabaseClient

    init() {
        self.client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
        print("SupabaseManager initialized")
    }
    func fetchUserProfile() async throws -> UserModel {
        let session = try await client.auth.session
        
        let currentUserID = session.user.id.uuidString
        
        let user: UserModel = try await client.database
            .from("profiles")
            .select()
            .eq("id", value: currentUserID)
            .single()
            .execute()
            .value
        
        return user
    }
    func updateProfile(user: UserModel) async throws {
        let updateDto = ProfileUpdate(
            name: user.name,
            email: user.email,
            phone: user.phone,
            profileImageUrl: user.profileImageUrl,
            updated_at: Date().ISO8601Format(),

        )
        try await client.database
            .from("profiles")
            .update(updateDto)
            .eq("id", value: user.id)
            .execute()
    }

    func singOut() async throws {
        try await client.auth.signOut()
    }

    // Dentro de la clase SupabaseManager

    func fetchBarbers() async throws -> [Barber] {
        // 1. Decodificar la respuesta de la BD al DTO
        let barberDTOs: [BarberDTO] = try await client.database
            .from("barbers")
            .select("*, latitude, longitude") // Asegúrate de pedir las columnas de coordenadas
            .order("rating", ascending: false)
            .execute()
            .value

        // 2. Mapear los DTOs al modelo de aplicación [Barber]
        let barbers = barberDTOs.map { $0.toBarber() }
        
        return barbers
    }

    func fetchServices() async throws -> [Service] {
        let services: [Service] = try await client.database
            .from("services")
            .select()
            .execute()
            .value
        return services
    }

}

struct ProfileUpdate: Encodable{
    let name: String
    let email: String
    let phone: String
    let profileImageUrl: String
    let updated_at: String
}
enum AppError: Error, LocalizedError {
    case noAuthenticatedUser

    var errorDescription: String? {
        switch self {
        case .noAuthenticatedUser:
            return "No authenticated user found"
        }
    }
}
