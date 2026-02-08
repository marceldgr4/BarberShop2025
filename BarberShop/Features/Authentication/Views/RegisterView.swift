//
//  RegisterView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 19/11/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var agreeToTerms = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.brandOrange, Color.orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Create Account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Sign up to get started")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 25)
                    
                    // MARK: - Form
                    VStack(spacing: 12) {
                        
                        // Full Name
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Full Name", systemImage: "person.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                TextField("Full Name", text: $fullName)
                                    .textInputAutocapitalization(.words)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        // Phone
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Phone Number", systemImage: "phone.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Image(systemName: "phone")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                TextField("+57 3xx xxx xxxx", text: $phone)
                                    .keyboardType(.phonePad)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        // Email
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
                        
                        // Password
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
                                    TextField("Minimum 6 characters", text: $password)
                                } else {
                                    SecureField("Minimum 6 characters", text: $password)
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
                                    .stroke(passwordStrengthColor, lineWidth: password.isEmpty ? 1 : 2)
                            )
                            
                            // Password strength indicator
                            if !password.isEmpty {
                                HStack(spacing: 4) {
                                    ForEach(0..<3) { index in
                                        Rectangle()
                                            .fill(index < passwordStrength ? passwordStrengthColor : Color.gray.opacity(0.3))
                                            .frame(height: 4)
                                            .cornerRadius(2)
                                    }
                                }
                                
                                Text(passwordStrengthText)
                                    .font(.caption)
                                    .foregroundColor(passwordStrengthColor)
                            }
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Confirm Password", systemImage: "lock.shield.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Image(systemName: "lock.shield")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                if isConfirmPasswordVisible {
                                    TextField("Re-enter password", text: $confirmPassword)
                                } else {
                                    SecureField("Re-enter password", text: $confirmPassword)
                                }
                                
                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        confirmPassword.isEmpty ? Color.gray.opacity(0.2) :
                                        (password == confirmPassword ? Color.green : Color.red),
                                        lineWidth: confirmPassword.isEmpty ? 1 : 2
                                    )
                            )
                            
                            // Match indicator
                            if !confirmPassword.isEmpty {
                                HStack(spacing: 5) {
                                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                    Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                                        .font(.caption)
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                }
                            }
                        }
                        Spacer()
                        // Terms & Conditions
                        HStack(alignment: .top, spacing: 8) {
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    agreeToTerms.toggle()
                                }
                            }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreeToTerms ? Color.brandOrange : .gray)
                                    .font(.title3)
                            }
                            
                            VStack(alignment: .leading, spacing: 23) {
                                HStack(spacing: 3) {
                                    Text("I agree to the")
                                        .foregroundColor(.primary)
                                    Button("Terms & Conditions") {
                                        // TODO: Mostrar términos
                                    }
                                    .foregroundColor(Color.brandOrange)
                                    .fontWeight(.semibold)
                                    
                                    Text("and")
                                        .foregroundColor(.primary)
                                    Button("Privacy Policy") {
                                        // TODO: Mostrar política
                                    }
                                    .foregroundColor(Color.brandOrange)
                                    .fontWeight(.semibold)
                                }
                                .font(.caption)
                            }
                            .padding(.top, 3)
                            
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
                        
                        // Sign Up Button
                        Button(action: {
                            Task {
                                await authViewModel.signUp(
                                    email: email,
                                    password: password,
                                    fullName: fullName,
                                    phone: phone
                                )
                                if authViewModel.isAuthenticated {
                                    dismiss()
                                }
                            }
                        }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    Text("Creating account...")
                                        .fontWeight(.semibold)
                                } else {
                                    Text("Create Account")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.brandOrange, Color.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.brandOrange.opacity(0.3), radius: 8, y: 4)
                        }
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity((authViewModel.isLoading || !isFormValid) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Sign In Link
                    HStack(spacing: 5) {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundColor(Color.brandOrange)
                        }
                    }
                    .font(.subheadline)
                    .padding(.bottom, 25)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        !phone.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
        agreeToTerms
    }
    
    private var passwordStrength: Int {
        var strength = 0
        if password.count >= 6 { strength += 1 }
        if password.count >= 10 { strength += 1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil &&
           password.rangeOfCharacter(from: .letters) != nil {
            strength += 1
        }
        return strength
    }
    
    private var passwordStrengthColor: Color {
        switch passwordStrength {
        case 0: return .gray.opacity(0.2)
        case 1: return .red
        case 2: return .orange
        case 3: return .green
        default: return .gray
        }
    }
    
    private var passwordStrengthText: String {
        switch passwordStrength {
        case 0: return ""
        case 1: return "Weak password"
        case 2: return "Medium password"
        case 3: return "Strong password"
        default: return ""
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
