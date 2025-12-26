// MARK: - ViewModel
import Foundation
import Combine
@MainActor

class EditProfileViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var photoUrl: String?
    
    @Published var isLoading = false
    @Published var showSuccess = false
    @Published var errorMessage: String?
    
    private var originalUser: User?
    private let supabase = SupabaseManager.shared
    
    // ✅ Detecta si hay cambios
    var hasChanges: Bool {
        guard let original = originalUser else { return false }
        return fullName.trimmingCharacters(in: .whitespaces) != original.fullName ||
               phone.trimmingCharacters(in: .whitespaces) != (original.phone ?? "")
    }
    
    // ✅ Valida que los datos sean correctos
    var isValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func loadUser(_ user: User) {
        originalUser = user
        fullName = user.fullName
        phone = user.phone ?? ""
        email = user.email ?? ""
        photoUrl = user.photoUrl
    }
    
    func saveChanges() async {
        guard let userId = originalUser?.id else {
            errorMessage = "User ID not found"
            return
        }
        
        // ✅ Validación
        guard isValid else {
            errorMessage = "Name cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        showSuccess = false
        
        do {
            let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
            
            try await supabase.updateUser(
                userId: userId,
                fullName: fullName.trimmingCharacters(in: .whitespaces),
                phone: trimmedPhone.isEmpty ? nil : trimmedPhone
            )
            
            showSuccess = true
            print("✅ Profile updated successfully")
            
            // Actualizar el usuario original con los nuevos valores
            if var updatedUser = originalUser {
                updatedUser = User(
                    id: updatedUser.id,
                    fullName: fullName.trimmingCharacters(in: .whitespaces),
                    phone: trimmedPhone.isEmpty ? nil : trimmedPhone,
                    email: updatedUser.email,
                    photoUrl: updatedUser.photoUrl,
                   
                    isActive: updatedUser.isActive,
                    createdAt: updatedUser.createdAt,
                    updatedAt: Date(),
                    rolId: updatedUser.rolId,
                )
                originalUser = updatedUser
            }
            
        } catch {
            print("❌ Error saving profile: \(error)")
            errorMessage = error.localizedDescription
            showSuccess = false
        }
        
        isLoading = false
    }
    
    func discardChanges() {
        if let original = originalUser {
            fullName = original.fullName
            phone = original.phone ?? ""
            email = original.email ?? ""
        }
        errorMessage = nil
        showSuccess = false
    }
}
