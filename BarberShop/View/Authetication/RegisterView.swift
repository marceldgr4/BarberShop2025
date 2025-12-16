/*
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPasswordVisible = false
    @State private var agreeToTerms = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    
                    // Header
                    VStack(spacing: 10) {
                        Text("Create Account")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                        
                        Text("Fill your information below or register with your social account.")
                            .font(.system(size: 15, design: .serif))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 30)
                    
                    // Formulario
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Nombre
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Name:", systemImage: "person")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Full Name", text: $viewModel.userName)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .textInputAutocapitalization(.words)
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Email:", systemImage: "envelope")
                                .font(.headline)
                                .foregroundColor(.primary)
                            TextField("Example@email", text: $viewModel.userEmail)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Password:", systemImage: "key")
                                .font(.headline)
                                .foregroundColor(.primary)
                            HStack {
                                if isPasswordVisible {
                                    TextField("*******", text: $viewModel.userPassword)
                                } else {
                                    SecureField("*******", text: $viewModel.userPassword)
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        // Checkbox Terms & Conditions
                        HStack(spacing: 10) {
                            Button(action: {
                                withAnimation { agreeToTerms.toggle() }
                            }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreeToTerms ? .yellow : .gray)
                                    .font(.system(size: 20))
                            }
                            
                            HStack(spacing: 4) {
                                Text("Agree with")
                                    .foregroundColor(.primary)
                                Button("Terms & Conditions") {
                                    print("Abrir términos")
                                }
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                            }
                            .font(.subheadline)
                        }
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                    
                    // Botón Sign Up
                    Button(action: {
                        Task {
                            await viewModel.signUp()
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("Sign Up")
                            }
                        }
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.yellow : Color.gray)
                        .cornerRadius(30)
                    }
                    .disabled(!isFormValid || viewModel.isLoading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Divisor
                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                        Text("Or sign up with").font(.footnote).foregroundColor(.gray)
                        Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Footer
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.primary)
                        Button("Sign In") {
                            viewModel.clearFields()
                            dismiss()
                        }
                        .foregroundColor(.yellow)
                        .fontWeight(.bold)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.userName.isEmpty &&
        !viewModel.userEmail.isEmpty &&
        !viewModel.userPassword.isEmpty &&
        agreeToTerms
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
*/
