//
//  AuthenticationService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 26/12/25.
//

import Foundation
import Supabase

final class AuthenticationService{
    private let client: SupabaseClient
    private let decoder: JSONDecoder
    
    init(client: SupabaseClient = SupabaseManager.shared.client, decoder: JSONDecoder = SupabaseManager.shared.decoder) {
        self.client = client
        self.decoder = decoder
    }
    
    /// Registra un nuevo usuario
    func signUp(email: String, password: String, fullName: String, phone: String) async throws -> User {
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        let userId = authResponse.user.id
        let defaultRoleId = try await getDefaultUserRoleId()
        
        let newUser = User(
            id: userId,
            fullName: fullName,
            phone: phone,
            email: email,
            photoUrl: nil,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date(),
            rolId: defaultRoleId,
        )
        
        try await client
            .from("users")
            .insert(newUser)
            .execute()
        
        return newUser
    }
    
    /// Inicia sesión
    func signIn(email: String, password: String) async throws -> String {
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )
        return response.user.id.uuidString
    }
    
    /// Cierra sesión
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    /// Obtiene el usuario actual
    func getCurrentUser() async throws -> User? {
        let session = try await client.auth.session
        
        let response = try await client
            .from("users")
            .select()
            .eq("id", value: session.user.id.uuidString)
            .single()
            .execute()
        
        return try decoder.decode(User.self, from: response.data)
    }
    
    /// Obtiene el rol por defecto (cliente)
    private func getDefaultUserRoleId() async throws -> UUID? {
        let response = try await client
            .from("roles")
            .select()
            .eq("role_name", value: "cliente")
            .single()
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        guard let roleIdString = json?["id"] as? String else {
            return nil
        }
        return UUID(uuidString: roleIdString)
    }
    
    /// Actualiza información del usuario
    func updateUser(
        userId: UUID,
        fullName: String? = nil,
        phone: String? = nil,
        photoUrl: String? = nil
    ) async throws {
        let update = UserUpdate(
            fullName: fullName,
            phone: phone,
            photoUrl: photoUrl, updatedAt: Date()
        )
        
        try await client
            .from("users")
            .update(update)
            .eq("id", value: userId.uuidString)
            .execute()
        
        print("Usuario actualizado en Supabase")
    }
    
    /// Resetea la contraseña del usuario
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    
    
}
