//
//  ForgotPasswordView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // MARK: - Header
                        VStack(spacing: 15) {
                            Image(systemName: "envelope.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(Color.brandGradientVertical)
                            
                            Text("Reset Password")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Enter your email and we'll send you instructions to reset your password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 40)
                        
                        // MARK: - Form
                        VStack(spacing: 20) {
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Email Address", systemImage: "envelope.fill")
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
                            
                            // Success Message
                            if showSuccess {
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title3)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Email Sent!")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)
                                        
                                        Text("Check your inbox for reset instructions")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                                .transition(.scale.combined(with: .opacity))
                            }
                            
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
                            
                            // Send Reset Link Button
                            Button(action: {
                                Task {
                                    await authViewModel.resetPassword(email: email)
                                    withAnimation(.spring(response: 0.5)) {
                                        showSuccess = true
                                    }
                                    
                                    // Auto-dismiss después de 2.5 segundos
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        dismiss()
                                    }
                                }
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("Sending...")
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("Send Reset Link")
                                            .fontWeight(.bold)
                                        Image(systemName: "paperplane.fill")
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandGradient)
                                .cornerRadius(12)
                                .shadow(color: Color.brandOrange.opacity(0.3), radius: 8, y: 4)
                            }
                            .disabled(authViewModel.isLoading || !isEmailValid)
                            .opacity((authViewModel.isLoading || !isEmailValid) ? 0.6 : 1.0)
                        }
                        .padding(.horizontal, 25)
                        
                        Spacer()
                        
                        // MARK: - Back to Login
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "arrow.left")
                                Text("Back to Sign In")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color.brandOrange)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
            }
        }
    }
    
    private var isEmailValid: Bool {
        !email.isEmpty && email.contains("@") && email.contains(".")
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
