//
//  NewPasswordView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/11/25.
//
/*
import SwiftUI

struct NewPasswordView: View {
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    // Estados independientes para la visibilidad de cada campo
    @State private var isNewPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background") // Asegúrate de tener este color en Assets
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // --- Header ---
                        VStack(spacing: 10) {
                            Text("New Password")
                                .font(.system(size: 40, weight: .bold, design: .serif))
                                .foregroundColor(.primary)
                            
                            Text("Your new password must be different from previously used passwords.")
                                .font(.system(size: 15, design: .serif))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 40)
                        
                        // --- Campos de Contraseña ---
                        VStack(alignment: .leading, spacing: 25) {
                            
                            // 1. Nueva Contraseña
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Password:", systemImage: "lock")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    if isNewPasswordVisible {
                                        TextField("*******", text: $newPassword)
                                    } else {
                                        SecureField("*******", text: $newPassword)
                                    }
                                    
                                    Button(action: { isNewPasswordVisible.toggle() }) {
                                        Image(systemName: isNewPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            // 2. Confirmar Contraseña
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Confirm Password:", systemImage: "lock.shield") // Icono diferente para diferenciar
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    if isConfirmPasswordVisible {
                                        TextField("*******", text: $confirmPassword)
                                    } else {
                                        SecureField("*******", text: $confirmPassword)
                                    }
                                    
                                    Button(action: { isConfirmPasswordVisible.toggle() }) {
                                        Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // --- Botón de Acción ---
                        Button(action: {
                            // Validar que sean iguales antes de guardar
                            if newPassword == confirmPassword && !newPassword.isEmpty {
                                print("Contraseña actualizada correctamente")
                                // Aquí navegarías al Login o al Home
                            } else {
                                print("Las contraseñas no coinciden")
                            }
                        }) {
                            Text("Create New Password")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(30)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
            // Botón para volver atrás (opcional, por si el usuario quiere cancelar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                }
            }
        }
    }
}

#Preview {
    NewPasswordView()
}
*/
