//
//  LoginView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 18/11/25.
//
/*/
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var passsword = ""
    @State private var shwoRegister = false
    @State private var showForgotPassword = false
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Header
                        VStack(spacing: 5) {
                            Text("Sign In")
                                .font(.system(size: 50, weight: .bold, design: .serif))
                                .foregroundColor(.primary)
                            
                            Text("Hi! welcome back, you've been missed")
                                .font(.system(size: 15, design: .serif))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        Spacer().frame(height: 10)
                        
                        // Formulario
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Email:", systemImage: "envelope")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Example@email", text: $email)
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
                                        TextField("*******", text: $passsword)
                                    } else {
                                        SecureField("*******", text: $passsword)
                                    }
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            
                            // Forgot password
                            HStack {
                                Spacer()
                                Button("Forgot password?") {
                                    // Acción recuperar
                                }
                                .foregroundColor(.blue)
                                .font(.subheadline)
                                .underline()
                            }
                            
                            // Botón Sign In
                            Button(action: {
                                Task {
                                    await viewModel.signIn(email: email, password: passsword)
                                }
                            }) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text("Sign In")
                                        .font(.headline)
                                }
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        // Divisor
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                            Text("Or sign in with").font(.footnote).foregroundColor(.gray)
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                        }
                        .padding(.horizontal, 20)
                        
                        // Redes Sociales
                        HStack(spacing: 30) {
                            SocialButton(iconName: "applelogo", color: .primary)
                            
                            Button(action: {}) {
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(gradient: Gradient(colors: [.orange, .red, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "f.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        Spacer()
                        
                        // Footer
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.primary)
                            
                            NavigationLink(destination: RegisterView()) {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
          
        }
    }
}

struct SocialButton: View {
    var iconName: String
    var color: Color
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundColor(color)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
*/
