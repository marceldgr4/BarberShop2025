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
            
            
            let formatter1 = ISO8601DateFormatter()
            formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter1.date(from: dateString) {
                return date
            }
            
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        return decoder
    }()
    
    // MARK: - Conexion con supabase
    private init() {
        let supabaseUrl: URL = URL(string: "https://vxcaadneaegpuqhtgkhz.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4Y2FhZG5lYWVncHVxaHRna2h6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1MjA1MjYsImV4cCI6MjA3OTA5NjUyNn0.5oYbrcyYSQTcEiDi0zR6Umr5ZGKbjOFu-GsQs0SwcP0"
        
        client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
        )
    }
}
