//
//  SupabaseManager.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//


import Foundation
import Supabase


final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    
    private init(){
        let supabaseUrl: URL = URL(string: "https://vxcaadneaegpuqhtgkhz.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4Y2FhZG5lYWVncHVxaHRna2h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1MjA1MjYsImV4cCI6MjA3OTA5NjUyNn0.5oYbrcyYSQTcEiDi0zR6Umr5ZGKbjOFu-GsQs0SwcP0"
        
        client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
        
    }
    
    //MARK: REGISTER USER
    func signUp (email: String,  password: String, fullName: String, phone: String) async throws -> User{
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
         let userId = authResponse.user.id
           
        // MARK: CREARTE NEW USER
        let newUser = User(
            id: userId,
            fullName: fullName,
            phone: phone,
            email: email,
            photoUrl: nil,
            isActive: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        try await client
            .from("users")
            .insert(newUser)
            .execute()
        return newUser
    }
    // MARK: - LOGING
    func signIn( email:String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    // MARK: - CLOSE THE SESSION
    func signOut() async throws{
        try await client.auth.signOut()
    }
    
    func  getCurrentUser() async throws -> User? {
         let session = try await client.auth.session
       
        
        let response = try await client
            .from("users")
            .select()
            .eq("id", value: session.user.id.uuidString)
            .single()
            .execute()
        return try JSONDecoder().decode(User.self, from: response.data)
    }
    
    func resetPassword(email: String) async throws{
        try await client.auth.resetPasswordForEmail(email)
    }
    // MARK: -BRANCH
    func fetchBranches() async throws -> [Branch]{
        let response = try await client
            .from("branches")
            .select()
            .eq("is_active", value: true)
            .execute()
        return try JSONDecoder().decode([Branch].self, from: response.data)
    }
    
    func fetchBranchHours(branchId: UUID) async throws -> [BranchHours]{
        let response = try await client
            .from("branch_hours")
            .select()
            .eq("branch_id", value: branchId.uuidString)
            .execute()
        
        return try JSONDecoder().decode([BranchHours].self, from: response.data)
    }
    // MARK: -SERVICES
    func fetchServices() async throws ->[Service]{
            let response = try await client
            .from("services")
            .select()
            .eq("is_active", value: true)
            .execute()
        
        return try JSONDecoder().decode([Service].self, from: response.data)
    }
    
    
    func fecthServiceCategories() async throws -> [ServiceCategory] {
        let response = try await client
            .from("service_categories")
            .select()
            .execute()
        
        return try JSONDecoder().decode([ServiceCategory].self, from: response.data)
        
    }
    //MARK: BARBERS
    func fetchBarbers(branchId: UUID? = nil) async throws -> [BarberWithRating]{
        var query = client
            .from("barbers")
            .select("""
                    id, 
                    branch_id, 
                    specialty_id,
                    name, 
                    photo_url,
                    
                    is_active,
                    barber_ratings!inner(averaga_rating, total_reviews)
                    """)
            .eq("is_active", value: true)
        if let branchId = branchId {
            query = query.eq("branch_id", value: branchId.uuidString)
            
        }
        let response = try await query.execute()
        
        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []
        
        return json.compactMap { dict -> BarberWithRating? in
            guard let id = dict["id"] as? String,
                  let branchId =  dict["branch_id"] as? String,
                  let name = dict["name"] as? String,
                  let isActive = dict["is_active"] as? Bool,
                  let ratings = dict["barber_ratings"] as? [String: Any],
                  let avgRating = ratings["average_rating"] as? Double,
                  let totalReviews = ratings["total_reviews"] as? Int
            else{return nil}
            
            return BarberWithRating(id: UUID(uuidString: id) ?? UUID(),
                                    branchId: UUID(uuidString: branchId) ?? UUID(),
                                    specialtyId:(dict["specialty_id"] as? String).flatMap{ UUID(uuidString: $0)} ,
                                    name: name,
                                    photoUrl: dict["photo_url"] as? String,
                                    isActive: isActive,
                                    rating: avgRating,
                                    totalReviews: totalReviews)
        }
    }
    //MARK: CREATE THE APPOINTMENT
    func createAppointment(
        branchId:UUID,
        barberId:UUID,
        serviceId:UUID,
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
        let statuData = try JSONSerialization.jsonObject(with: statusResponse.data) as? [String: Any]
        guard let statusId = statuData?["id"] as? String else{
            throw NSError(domain: "Appointment", code: 1, userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }
        let appointment = Appointment(id: UUID(),
                                      userId: userId,
                                      branchId: branchId,
                                      barberId: barberId,
                                      serviceId: serviceId,
                                      statusId: UUID(uuidString: statusId)!,
                                      appointmentDate: date,
                                      appointmentTime: time,
                                      totalPrice: price,
                                      notes: notes!,
                                      createdAt: Date(),
                                      updatedAt: Date()
        )
        try await client
            .from("appointments")
            .insert(appointment)
            .execute()
        return appointment
    }
    func fecthUserAppointments() async throws -> [AppointmentDetail]{
         let userId = try await client.auth.session.user.id
        let response = try await client
            .from("appointments")
            .select("""
                    id,
                    appointment_date, 
                    appointment_time,
                    total_price, notes,                    
                    appointment_status!inner(status_name),
                    barbers!inner(name, photo_url),
                    services!inner(name),
                    branches!inner(name, address)
                """)
                    .eq("user_id", value: userId.uuidString)
                    .order("appointment_date", ascending: false)
                    .execute()
                
                // Parse manual del JOIN
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
                        barberPhoto: (barber["photo_url"] as? String)!,
                        serviceName: serviceName,
                        branchName: branchName,
                        branchAddress: branchAddress
                    )
                }
            }
            
            // MARK: - Reviews
            
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
                    comment: comment!,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                try await client
                    .from("reviews")
                    .insert(review)
                    .execute()
            }
            
            func fetchReviews(barberId: UUID) async throws -> [Review] {
                let response = try await client
                    .from("reviews")
                    .select()
                    .eq("barber_id", value: barberId.uuidString)
                    .order("created_at", ascending: false)
                    .execute()
                
                return try JSONDecoder().decode([Review].self, from: response.data)
            }
            
            // MARK: - Promotions
            
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
                
                return try JSONDecoder().decode([Promotion].self, from: response.data)
            }
            
            // MARK: - Favorite Barbers
            
            func toggleFavoriteBarber(barberId: UUID) async throws {
              let userId = try await client.auth.session.user.id
                
                // Check if already favorite
                let response = try await client
                    .from("favorite_barbers")
                    .select()
                    .eq("user_id", value: userId.uuidString)
                    .eq("barber_id", value: barberId.uuidString)
                    .execute()
                
                if response.data.isEmpty {
                    // Add to favorites
                    try await client
                        .from("favorite_barbers")
                        .insert([
                            "user_id": userId.uuidString,
                            "barber_id": barberId.uuidString
                        ])
                        .execute()
                } else {
                    // Remove from favorites
                    try await client
                        .from("favorite_barbers")
                        .delete()
                        .eq("user_id", value: userId.uuidString)
                        .eq("barber_id", value: barberId.uuidString)
                        .execute()
                }
            }
            
            func fetchFavoriteBarbers() async throws -> [BarberWithRating] {
                let userId = try await client.auth.session.user.id
                
                let response = try await client
                    .from("favorite_barbers")
                    .select("""
                        barbers!inner(id, branch_id, 
                    specialty_id, 
                    name, 
                    photo_url,                    
                    is_active,
                    barber_ratings(average_rating, total_reviews))
                    """)
                    .eq("user_id", value: userId.uuidString)
                    .execute()
                
                // Parse manual
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
