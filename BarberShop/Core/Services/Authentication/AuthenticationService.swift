import Foundation
import Supabase
import Combine

@MainActor
class AuthenticationService: ObservableObject {

    static let shared = AuthenticationService()

    private let client: SupabaseClient
    private let decoder: JSONDecoder

    init(
        client: SupabaseClient = SupabaseManagerSecure.shared.client,
        decoder: JSONDecoder = SupabaseManagerSecure.shared.decoder
    ) {
        self.client = client
        self.decoder = decoder
    }

    @Published var currentProfile: Profile?
    @Published var isAuthenticated = false

    /// Registra un nuevo usuario
    func signUp(
        email: String,
        password: String,
        fullName: String,
        phone: String? = nil
    ) async throws -> Profile {
        
        // Pasar metadata para que el trigger create_profile_for_user() lo use
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password,
            data: [
                "full_name": .string(fullName),
                "phone": .string(phone ?? "")
            ]
        )

        let userId = authResponse.user.id
        


        // El trigger ya creó el perfil, solo actualizamos el teléfono si existe
        if let phone = phone, !phone.isEmpty {
            try await updateProfile(
                userId: userId,
                phone: phone
            )
        }

        // Obtener el perfil recién creado
        let profile = try await getProfile(userId: userId)
        
        guard let profile = profile else {
            throw NSError(
                domain: "Auth",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Profile not created"]
            )
        }

        return profile
    }

    /// Inicia sesión
    func signIn(email: String, password: String) async throws -> UUID {
        
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )

        
        let userId = response.user.id


        // Cargar el perfil después del login
        try await fetchCurrentProfile()

        return userId
    }

    /// Cierra sesión
    func signOut() async throws {
        try await client.auth.signOut()
        currentProfile = nil
        isAuthenticated = false
    }

    /// Obtiene el usuario actual desde la sesión
    func getCurrentUser() async throws -> Profile? {
        
        let session = try await client.auth.session
        return try await getProfile(userId: session.user.id)
    }

    /// Obtiene un perfil por UUID
    func getProfile(userId: UUID) async throws -> Profile? {
        
        let response = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()

        let profile = try decoder.decode(Profile.self, from: response.data)
        return profile
    }

    /// Obtiene el rol del usuario
    func getUserRole(userId: UUID) async throws -> Role? {
        
        let response = try await client
            .from("user_roles")
            .select("""
                id,
                user_id,
                role_id,
                barbershop_id,
                roles!inner(id, name, description)
            """)
            .eq("user_id", value: userId.uuidString)
            .limit(1)
            .execute()

        let userRoles = try decoder.decode([UserRole].self, from: response.data)
        return userRoles.first?.role
    }

    /// Actualiza información del perfil
    func updateProfile(
        userId: UUID,
        fullName: String? = nil,
        phone: String? = nil,
        avatarUrl: String? = nil
    ) async throws {
        
        var updates: [String: AnyJSON] = [
            "updated_at": .string(ISO8601DateFormatter().string(from: Date()))
        ]
        
        if let fullName = fullName {
            updates["full_name"] = .string(fullName)
        }
        
        if let phone = phone {
            updates["phone"] = .string(phone)
        }
        
        if let avatarUrl = avatarUrl {
            updates["avatar_url"] = .string(avatarUrl)
        }

        try await client
            .from("profiles")
            .update(updates)
            .eq("id", value: userId.uuidString)
            .execute()

        print("✅ Perfil actualizado en Supabase")
        
        // Recargar el perfil actual si es el usuario logueado
        if currentProfile?.id == userId {
            try await fetchCurrentProfile()
        }
    }

    /// Resetea la contraseña del usuario
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }

    /// Carga el perfil actual
    func fetchCurrentProfile() async throws {
        
        let profile = try await getCurrentUser()

        await MainActor.run {
            self.currentProfile = profile
            self.isAuthenticated = profile != nil
        }
    }

    /// Refresca la sesión
    func refreshSession() async throws {
        
        _ = try await client.auth.session
        try await fetchCurrentProfile()
    }
    
    /// Verifica si el usuario actual es super admin
    func isUserSuperAdmin() async throws -> Bool {
        
        guard let userId = currentProfile?.id else {
            return false
        }
        
        let role = try await getUserRole(userId: userId)
        return role?.name == "super_admin"
    }
    
    /// Verifica si el usuario es admin de una barbería específica
    func isUserBarbershopAdmin(barbershopId: UUID) async throws -> Bool {
        
        guard let userId = currentProfile?.id else {
            return false
        }
        
        let response = try await client
            .from("user_roles")
            .select("""
                id,
                barbershop_id,
                roles!inner(name)
            """)
            .eq("user_id", value: userId.uuidString)
            .eq("barbershop_id", value: barbershopId.uuidString)
            .execute()
        
        let userRoles = try decoder.decode([UserRole].self, from: response.data)
        
        return userRoles.first?.role?.name == "barbershop_admin"
    }
}
