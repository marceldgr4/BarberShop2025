import Foundation
import Supabase

final class SupabaseManagerSecure {
    static let shared = SupabaseManagerSecure()
    let client: SupabaseClient
    
    // MARK: - Custom Date Decoder
    internal let decoder: JSONDecoder = {
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
        do{
            let supabaseUrl = try ConfigManager.shared.getSupabaseURL()
            let supabaseKey = try ConfigManager.shared.getSupabaseKey()
            
            
            client = SupabaseClient(
                supabaseURL: supabaseUrl,
                supabaseKey: supabaseKey
            )
            print("Supabase inicializado correctamnete")
        }catch{
            fatalError("Error al inicializar Supabase: \(error.localizedDescription)")
        }
    }
}
