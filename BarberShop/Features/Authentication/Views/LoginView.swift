//
//  LoginView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showForgotPassword = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // MARK: - Logo y Título
                        VStack(spacing: 15) {
                            Image(systemName: "scissors.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Color.brandGradientVertical)
                            
                            Text("BarberShop")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Sign in to continue")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        // MARK: - Formulario
                        VStack(spacing: 20) {
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Email", systemImage: "envelope.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.gray)
                                        .frame(width: 20)
                                    
                                    TextField("ejemplo@email.com", text: $email)
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.emailAddress)
                                        .autocorrectionDisabled()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Password", systemImage: "lock.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.gray)
                                        .frame(width: 20)
                                    
                                    if isPasswordVisible {
                                        TextField("Enter your password", text: $password)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                    }
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Forgot Password
                            HStack {
                                Spacer()
                                Button(action: {
                                    showForgotPassword = true
                                }) {
                                    Text("Forgot Password?")
                                        .font(.subheadline)
                                        .foregroundColor(Color.brandOrange)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.top, -10)
                            
                            // Error Message
                            if let errorMessage = authViewModel.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(errorMessage)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            // Sign In Button
                            Button(action: {
                                Task {
                                    await authViewModel.signIn(email: email, password: password)
                                }
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("Signing in...")
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("Sign In")
                                            .fontWeight(.bold)
                                        Image(systemName: "arrow.right")
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandGradient)
                                .cornerRadius(12)
                                .shadow(color: Color.brandOrange.opacity(0.3), radius: 8, y: 4)
                            }
                            .disabled(authViewModel.isLoading || !isFormValid)
                            .opacity((authViewModel.isLoading || !isFormValid) ? 0.6 : 1.0)
                        }
                        .padding(.horizontal, 25)
                    }
                    .padding()
                    
                        // MARK: - Sign Up Link
                        HStack(spacing: 10) {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                showRegister = true
                            }) {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.brandOrange)
                            }
                        }
                    
                        .font(.subheadline)
                  
                        
                        .padding(.bottom, 15)
                        // MARK: - Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("or")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 25)
                        
                        // MARK: - Social Login (Placeholder)
                        VStack(spacing: 12) {
                            SocialLoginButton(
                                icon: "applelogo",
                                text: "Continue with Apple",
                                action: {
                                    // TODO: Implementar Sign in with Apple
                                }
                            )
                            
                            SocialLoginButton(
                                icon: "g.circle.fill",
                                text: "Continue with Google",
                                action: {
                                    // TODO: Implementar Sign in with Google
                                }
                            )
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                }
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        email.contains("@") &&
        password.count >= 6
    }

}



// MARK: - Preview
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
