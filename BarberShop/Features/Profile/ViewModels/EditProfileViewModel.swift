// MARK: - ViewModel
import Foundation
import Combine
import PhotosUI
import SwiftUI
import UIKit

@MainActor
class EditProfileViewModel: ObservableObject {
    
    @Published var fullName = ""
    @Published var phone = ""
    @Published var avatarUrl: String?
    
    // Imagen
    @Published var selectedImage: UIImage?
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var showImagePicker = false
    @Published var isUploadingImage = false
    
    @Published var isLoading = false
    @Published var showSuccess = false
    @Published var errorMessage: String?
    
    private var originalUser: Profile?
    
    private let profileUserService = AuthenticationService()
    private let imagenUploadService = ImageUploadService()
    
    // MARK: - Validaciones
    
    var hasChanges: Bool {
        guard let original = originalUser else { return false }
        
        return fullName.trimmingCharacters(in: .whitespaces) != original.fullName ||
        phone.trimmingCharacters(in: .whitespaces) != (original.phone ?? "") ||
        selectedImage != nil
    }
    
    var isValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Load User
    
    func loadUser(_ user: Profile) {
        originalUser = user
        fullName = user.fullName
        phone = user.phone ?? ""
        avatarUrl = user.avatarUrl
    }
    
    // MARK: - Save
    
    func saveChanges() async {
        
        guard let userId = originalUser?.id else {
            errorMessage = "User ID not found"
            return
        }
        
        guard isValid else {
            errorMessage = "Name cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        showSuccess = false
        
        do {
            
            var updatedPhotoUrl = avatarUrl
            
            // Subir nueva imagen
            if let newImage = selectedImage {
                
                isUploadingImage = true
                
                if let oldUrl = avatarUrl {
                    try? await imagenUploadService.deleteProfileImage(imageURL: oldUrl)
                }
                
                updatedPhotoUrl = try await imagenUploadService.uploadProfileImage(
                    userId: userId,
                    image: newImage
                )
                
                isUploadingImage = false
            }
            
            let trimmedName = fullName.trimmingCharacters(in: .whitespaces)
            let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
            
            try await profileUserService.updateProfile(
                userId: userId,
                fullName: trimmedName,
                phone: trimmedPhone.isEmpty ? nil : trimmedPhone,
                avatarUrl: updatedPhotoUrl
            )
            
            // Actualizar estado local
            originalUser = Profile(
                id: userId,
                fullName: trimmedName,
                avatarUrl: updatedPhotoUrl,
                phone: trimmedPhone.isEmpty ? nil : trimmedPhone,
                isActive: originalUser?.isActive ?? true,
                createdAt: originalUser?.createdAt ?? Date(),
                updatedAt: Date(),
                //rolId: originalUser?.rolId ?? 0
            )
            
            avatarUrl = updatedPhotoUrl
            selectedImage = nil
            
            showSuccess = true
            
            print("✅ Profile updated successfully")
            
        } catch {
            
            print("❌ Error saving profile: \(error)")
            errorMessage = error.localizedDescription
            showSuccess = false
        }
        
        isLoading = false
    }
    
    // MARK: - Discard
    
    func discardChanges() {
        guard let original = originalUser else { return }
        
        fullName = original.fullName
        phone = original.phone ?? ""
        avatarUrl = original.avatarUrl
        
        selectedImage = nil
        
        errorMessage = nil
        showSuccess = false
    }
    
    // MARK: - Image Selection
    
    func handleImagenSelection() {
        Task {
            
            guard let photoItem = selectedPhotoItem else { return }
            
            do {
                
                guard let imageData = try await photoItem.loadTransferable(type: Data.self),
                      let image = UIImage(data: imageData) else {
                    
                    errorMessage = "Could not load image"
                    return
                }
                
                selectedImage = image
                
                print("image selected successfully")
                
            } catch {
                
                errorMessage = "Error loading image: \(error.localizedDescription)"
                print("❌ Error loading image: \(error)")
            }
        }
    }
}
