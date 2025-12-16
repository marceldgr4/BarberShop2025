import SwiftUI

/**
 * Vista de perfil del usuario.
 * Permite al usuario ver, editar su información (RF05) y cerrar sesión (RF03).
 *
 * Ubicación: View/ProfileView.swift
 
struct ProfileView: View {
    // Inyectamos el ViewModel. Usamos @StateObject porque esta vista es la "dueña" del ciclo de vida del VM.
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Cargando perfil...")
                        .controlSize(.large)
                } else if let user = viewModel.user {
                    // Si tenemos usuario, mostramos el formulario de edición
                    // Pasamos un Binding ($) para que el formulario pueda modificar los datos
                    EditProfileForm(user: $viewModel.user.toNonOptional(defaultValue: user), viewModel: viewModel)
                } else {
                    // Estado de error o vacío
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No se pudo cargar el perfil")
                            .font(.headline)
                        Button("Reintentar") {
                            viewModel.loadUserProfile()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(hex: "#EE8F40"))
                    }
                }
            }
            .navigationTitle("Mi Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.user != nil {
                        Button {
                            // Acción de guardar (RF05)
                            viewModel.saveProfile()
                        } label: {
                            if viewModel.isSaving {
                                ProgressView()
                            } else {
                                Text("Guardar")
                                    .fontWeight(.bold)
                            }
                        }
                        .disabled(viewModel.isSaving || viewModel.isLoading)
                        // Usamos el color de marca (Naranja)
                        .tint(Color(hex: "#EE8F40"))
                    }
                }
            }
        }
        .onAppear {
            // Cargar datos al aparecer la vista si aún no existen
            if viewModel.user == nil {
                viewModel.loadUserProfile()
            }
        }
    }
}

// MARK: - Formulario de Edición
private struct EditProfileForm: View {
    @Binding var user: UserModel
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        Form {
            // SECCIÓN 1: Avatar y Biografía
            Section {
                VStack(spacing: 15) {
                    HStack {
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            // Avatar Placeholder
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color(hex: "#EE8F40"))
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            
                            // Botón de edición de cámara (Visual)
                            Button(action: {
                                print("Abrir selector de fotos (Próximamente con Supabase Storage)")
                            }) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    
                }
                .listRowBackground(Color.clear) // Hace transparente el fondo de la celda
                .listRowSeparator(.hidden)
            }
            
            // SECCIÓN 2: Información Personal
            Section(header: Text("Información Personal")) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    TextField("Nombre Completo", text: $user.name)
                }
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    TextField("Teléfono", text: $user.phone)
                        .keyboardType(.phonePad)
                }
            }
            
            // SECCIÓN 3: Datos de Cuenta (Solo Lectura)
            Section(header: Text("Datos de Cuenta"), footer: Text("El correo electrónico no se puede cambiar.")) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    TextField("Email", text: $user.email)
                        .foregroundColor(.gray)
                        .disabled(true) // Deshabilitado
                }
            }
            
            // SECCIÓN 4: Acciones (Logout)
            Section {
                Button(action: {
                    print("Cerrando sesión... (Llamada a Supabase Auth)")
                    // Aquí llamarías a viewModel.logout()
                }) {
                    HStack {
                        Spacer()
                        Text("Cerrar Sesión")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .foregroundColor(.red)
            }
        }
        .alert("Mensaje", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Helpers

// Helper para manejar Bindings opcionales de String de forma segura
extension Binding where Value == String? {
    var bound: Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}

// Helper para convertir Binding<T?> a Binding<T>
extension Binding {
    func toNonOptional<T>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}



#Preview {
    ProfileView()
}
*/
