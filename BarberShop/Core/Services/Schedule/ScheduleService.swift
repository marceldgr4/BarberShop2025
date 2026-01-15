//
//  scheduleService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Supabase

final class ScheduleService{
    
     let client: SupabaseClient
     let decoder: JSONDecoder
    
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client,
         decoder: JSONDecoder = SupabaseManagerSecure.shared.decoder){
        self.client = client
        self.decoder = decoder
    }
    
    convenience init() {
            self.init(
                client: SupabaseManagerSecure.shared.client,
                decoder: SupabaseManagerSecure.shared.decoder
            )
        }
    
    
    
    
}
