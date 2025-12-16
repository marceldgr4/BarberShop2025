//
//  BarberShopApp.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//

import SwiftUI

@main
struct BarberShopApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated{
                //MainTabView().environmentObject(authViewModel)
            }else{
               // LoginView().environmentObject(authViewModel)
            }
            
        }
    }
}
