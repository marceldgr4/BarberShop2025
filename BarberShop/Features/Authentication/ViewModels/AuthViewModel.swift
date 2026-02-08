//
//  AuthViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/11/25.
//

import Foundation
//import SwiftUI
import Combine
//import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    private let authenticationService = AuthenticationService()
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    //private let supabase = SupabaseManager.shared
    
    init(){
        Task{
            await checkAuthStatus()
        }
    }
    
    func checkAuthStatus() async{
        do{
            currentUser = try await authenticationService.getCurrentUser()
            isAuthenticated = currentUser != nil
        } catch{
            isAuthenticated = false
        }
    }
    
    func signUp(
        email: String,
        password: String,
        fullName: String,
        phone: String
    ) async{
        isLoading = true
        errorMessage = nil
        
        do{
            currentUser = try await authenticationService.signUp(email: email, password: password, fullName: fullName, phone: phone)
            isAuthenticated = true
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func signIn(
        email: String,
        password: String
    ) async{
        isLoading = true
        errorMessage = nil
        
        do{
            try await authenticationService.signIn(email: email, password: password)
            await checkAuthStatus()
        }catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() async{
        do{
            try await authenticationService.signOut()
            currentUser = nil
            isAuthenticated = false
            
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func resetPassword(email: String) async{
        isLoading = true
        errorMessage = nil
        
        do {
            try await authenticationService.resetPassword(email: email)
        }catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
}
