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
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
            
            
            /*Group {
              
                
                if authViewModel.isAuthenticated {
                    MainTabView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}*/

/*Vista temporal para usuario autenticado
struct AuthenticatedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let user = authViewModel.currentUser {
                    Text("Hello, \(user.fullName)")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                Text("You are successfully logged in")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Info del usuario
                VStack(alignment: .leading, spacing: 12) {
                    if let user = authViewModel.currentUser {
                        InfoRow(icon: "person.fill", label: "Name", value: user.fullName)
                        InfoRow(icon: "envelope.fill", label: "Email", value: user.email ?? "N/A")
                        InfoRow(icon: "phone.fill", label: "Phone", value: user.phone ?? "N/A")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Botón de Sign Out
                Button(action: {
                    Task {
                        await authViewModel.signOut()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square")
                        Text("Sign Out")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

// Componente auxiliar para mostrar info
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}*/
