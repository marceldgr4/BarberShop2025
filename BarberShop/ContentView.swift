//
//  ContentView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//

import SwiftUI
import Supabase



struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isAuthenticated = false
    
    var body: some View {
        Group {
            if isAuthenticated {
               // MainTabView()
            } else {
               // LoginView()
            }
        }
        .environmentObject(authViewModel)
        .task {
            for await state in SupabaseManager.shared.client.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isAuthenticated = state.session != nil
                    
                    if isAuthenticated {
                        //$authViewModel.clearFields
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
