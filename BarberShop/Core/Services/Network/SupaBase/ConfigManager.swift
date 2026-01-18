//
//  ConfigManager.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation

final class ConfigManager{
    static let shared = ConfigManager()
    
    private init(){}
    
    func getSupabaseURL() throws -> URL{
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let url = URL(string: urlString) else{
            throw ConfigurationError.missingKey("SUPABASE_URL")
        }
            return url
    }
    func getSupabaseKey() throws ->String{
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else{
            throw ConfigurationError.missingKey("SUPABASE_ANON_KEY")
        }
        return key
        
    }
}
