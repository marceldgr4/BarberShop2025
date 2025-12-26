import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    
    // MARK: - Custom Date Decoder
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // ✅ OPCIÓN 1: ISO8601 con zona horaria y fracciones
            let formatter1 = ISO8601DateFormatter()
            formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter1.date(from: dateString) {
                return date
            }
            
            // ✅ OPCIÓN 2: ISO8601 con zona horaria, sin fracciones
            formatter1.formatOptions = [.withInternetDateTime]
            if let date = formatter1.date(from: dateString) {
                return date
            }
            
            // ✅ OPCIÓN 3: Formato Supabase sin zona horaria
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.timeZone = TimeZone(secondsFromGMT: 0)
            if let date = formatter2.date(from: dateString) {
                return date
            }
            
            // ✅ OPCIÓN 4: Sin milisegundos
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let date = formatter2.date(from: dateString) {
                return date
            }
            
            // ✅ OPCIÓN 5: Solo fecha
            formatter2.dateFormat = "yyyy-MM-dd"
            if let date = formatter2.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        return decoder
    }()
    
    // MARK: - Initialization
    private init() {
        let supabaseUrl: URL = URL(string: "https://vxcaadneaegpuqhtgkhz.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4Y2FhZG5lYWVncHVxaHRna2h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1MjA1MjYsImV4cCI6MjA3OTA5NjUyNn0.5oYbrcyYSQTcEiDi0zR6Umr5ZGKbjOFu-GsQs0SwcP0"
        
        client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - AUTHENTICATION
    
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
        
        print("✅ Usuario actualizado en Supabase")
    }
    
    /// Resetea la contraseña del usuario
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
    }
    
    // MARK: - BRANCHES
    
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
    
    // MARK: - SERVICES
    
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
    
    // MARK: - BARBERS
    
    /// Obtiene barberos con su calificación
    func fetchBarbers(branchId: UUID? = nil) async throws -> [BarberWithRating] {
        var query = client
            .from("barbers")
            .select("""
                id, 
                branch_id, 
                specialty_id,
                name, 
                photo_url,
                is_active,
                barber_ratings!inner(average_rating, total_reviews)
            """)
            .eq("is_active", value: true)
        
        if let branchId = branchId {
            query = query.eq("branch_id", value: branchId.uuidString)
        }
        
        let response = try await query.execute()
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        return json.compactMap { dict -> BarberWithRating? in
            guard let id = dict["id"] as? String,
                  let branchId = dict["branch_id"] as? String,
                  let name = dict["name"] as? String,
                  let isActive = dict["is_active"] as? Bool,
                  let ratings = dict["barber_ratings"] as? [String: Any],
                  let avgRating = ratings["average_rating"] as? Double,
                  let totalReviews = ratings["total_reviews"] as? Int
            else { return nil }
            
            return BarberWithRating(
                id: UUID(uuidString: id) ?? UUID(),
                branchId: UUID(uuidString: branchId) ?? UUID(),
                specialtyId: (dict["specialty_id"] as? String).flatMap { UUID(uuidString: $0) },
                name: name,
                photoUrl: dict["photo_url"] as? String,
                isActive: isActive,
                rating: avgRating,
                totalReviews: totalReviews
            )
        }
    }
    
    // MARK: - APPOINTMENTS
    
    /// Crea una nueva cita
    func createAppointment(
        branchId: UUID,
        barberId: UUID,
        serviceId: UUID,
        date: String,
        time: String,
        price: Double,
        notes: String?
    ) async throws -> Appointment {
        let userId = try await client.auth.session.user.id
        let statusResponse = try await client
            .from("appointment_status")
            .select()
            .eq("status_name", value: "pending")
            .single()
            .execute()
        
        let statusData = try JSONSerialization.jsonObject(with: statusResponse.data) as? [String: Any]
        guard let statusId = statusData?["id"] as? String else {
            throw NSError(domain: "Appointment", code: 1, userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }
        
        let appointment = Appointment(
            id: UUID(),
            userId: userId,
            branchId: branchId,
            barberId: barberId,
            serviceId: serviceId,
            statusId: UUID(uuidString: statusId)!,
            appointmentDate: date,
            appointmentTime: time,
            totalPrice: price,
            notes: notes,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await client
            .from("appointments")
            .insert(appointment)
            .execute()
        
        return appointment
    }
    
    /// Obtiene las citas del usuario actual
    func fecthUserAppointments() async throws -> [AppointmentDetail] {
        let userId = try await client.auth.session.user.id
        let response = try await client
            .from("appointments")
            .select("""
                id,
                appointment_date, 
                appointment_time,
                total_price, 
                notes,                    
                appointment_status!inner(status_name),
                barbers!inner(name, photo_url),
                services!inner(name),
                branches!inner(name, address)
            """)
            .eq("user_id", value: userId.uuidString)
            .order("appointment_date", ascending: false)
            .execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        return json.compactMap { dict -> AppointmentDetail? in
            guard let id = dict["id"] as? String,
                  let date = dict["appointment_date"] as? String,
                  let time = dict["appointment_time"] as? String,
                  let price = dict["total_price"] as? Double,
                  let status = dict["appointment_status"] as? [String: Any],
                  let statusName = status["status_name"] as? String,
                  let barber = dict["barbers"] as? [String: Any],
                  let barberName = barber["name"] as? String,
                  let service = dict["services"] as? [String: Any],
                  let serviceName = service["name"] as? String,
                  let branch = dict["branches"] as? [String: Any],
                  let branchName = branch["name"] as? String,
                  let branchAddress = branch["address"] as? String
            else { return nil }
            
            return AppointmentDetail(
                id: UUID(uuidString: id) ?? UUID(),
                appointmentDate: date,
                appointmentTime: time,
                totalPrice: price,
                notes: dict["notes"] as? String,
                statusName: statusName,
                barberName: barberName,
                barberPhoto: (barber["photo_url"] as? String) ?? "",
                serviceName: serviceName,
                branchName: branchName,
                branchAddress: branchAddress
            )
        }
    }
    
    // MARK: - REVIEWS
    
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
    
    // MARK: - PROMOTIONS
    
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
    
    // MARK: - FAVORITE BARBERS
    
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
