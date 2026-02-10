import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: User?
    @StateObject private var viewModel = EditProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isPickerPresented = false

    var body: some View {
        Form {
            // MARK: - Profile Photo Section
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: user?.photoUrl ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.brandAccent)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.brandOrange, lineWidth: 3)
                        )
                        PhotosPicker(
                            selection: $viewModel.selectedPhotoItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ){
                            HStack(spacing:6) {
                                Image(systemName: "camera.fill")
                                Text(viewModel.selectedImage != nil ? "Change photo": "Add photo")
                            }
                            /*
                             .font(.subheadline)
                             .fontWeight(.semibold)
                             .foregroundColor(.brandOrange)
                             .padding(.horizontal,16)
                             .padding(.vertical,8)
                             .background(Color.brandOrange.opacity(0.2))
                             .cornerRadius(20)
                             }
                             .onChange(of: viewModel.selectedPhotoItem) { _ in viewModel.handleImagenSelection()
                             }*/
                        }
                        .onAppear{
                            isPickerPresented = true
                        }
                        .onDisappear{
                            isPickerPresented = false
                        }
                        
                                  if viewModel.isUploadingImage {
                            HStack(spacing: 8){
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Uploading photo...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                        
                                  
                       
                    Spacer()
                }
                    .listRowBackground(Color.clear)
            }

            // MARK: - Personal Information
            Section("Personal Information") {
                // Full Name
                VStack(alignment: .leading, spacing: 8) {
                    Label("Full Name", systemImage: "person.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    TextField("Enter your name", text: $viewModel.fullName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                }

                // Phone
                VStack(alignment: .leading, spacing: 8) {
                    Label("Phone Number", systemImage: "phone.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    TextField("+57 3xx xxx xxxx", text: $viewModel.phone)
                        .keyboardType(.phonePad)
                        .textFieldStyle(.roundedBorder)
                }

                // Email (Solo lectura)
                VStack(alignment: .leading, spacing: 8) {
                    Label("Email", systemImage: "envelope.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(viewModel.email)
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .listRowBackground(Color.clear)
            }

            // MARK: - Success Message
            if viewModel.showSuccess {
                Section {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)

                        Text("Profile updated successfully!")
                            .font(.subheadline)
                            .foregroundColor(.green)

                        Spacer()
                    }
                }
                .listRowBackground(Color.green.opacity(0.1))
            }

            // MARK: - Error Message
            if let errorMessage = viewModel.errorMessage {
                Section {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)

                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)

                        Spacer()
                    }
                }
                .listRowBackground(Color.red.opacity(0.1))
            }

            // MARK: - Save Button
            Section {
                Button(action: {
                    Task {
                        await viewModel.saveChanges()
                        if viewModel.showSuccess {
                            // Esperar 1.5 segundos y cerrar
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                            dismiss()
                        }
                    }
                }) {
                    HStack {
                        Spacer()

                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Saving...")
                                .fontWeight(.semibold)
                        } else {
                            Text("Save Changes")
                                .fontWeight(.bold)
                            Image(systemName: "checkmark.circle.fill")
                        }

                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        // ✅ FIX: Ambos lados del ternario son del mismo tipo
                        Group {
                            if viewModel.hasChanges && viewModel.isValid {
                                LinearGradient(
                                    colors: [Color.brandSecondary, Color.brandPrimary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                LinearGradient(
                                    colors: [Color.gray, Color.gray],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                        }
                    )
                    .cornerRadius(12)
                }
                .disabled(!viewModel.hasChanges || !viewModel.isValid || viewModel.isLoading)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            // MARK: - Discard Changes Button
            if viewModel.hasChanges {
                Section {
                    Button(action: {
                        viewModel.discardChanges()
                    }) {
                        HStack {
                            Spacer()
                            Text("Discard Changes")
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isPickerPresented{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.brandAccent)
                }
            }
        }
        .onAppear {
            if let user = user {
                viewModel.loadUser(user)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EditProfileView(
            user: User(
                id: UUID(),
                fullName: "Marcel Diaz",
                phone: "+57 300 123 4567",
                email: "marcel@example.com",
                photoUrl: nil,
                isActive: true,
                createdAt: Date(),
                updatedAt: Date(),
                rolId: UUID(),
            ))
    }
}
