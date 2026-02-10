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
    @Published var email = ""
    @Published var photoUrl: String?
    
    ///propiedades para las imagen
    @Published var selectedImage: UIImage?
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var showImagePicker = false
    @Published var isUploadingImage = false
    
    
    @Published var isLoading = false
    @Published var showSuccess = false
    @Published var errorMessage: String?
    
    private var originalUser: User?
    private let supabase = SupabaseManagerSecure.shared
    private let profileUserService = AuthenticationService()
    private let imagenUploadService = ImageUploadService()
    
    
    var hasChanges: Bool {
        guard let original = originalUser else { return false }
        return fullName.trimmingCharacters(in: .whitespaces) != original.fullName ||
               phone.trimmingCharacters(in: .whitespaces) != (original.phone ?? "")
    }
    
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
        
        guard isValid else {
            errorMessage = "Name cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        showSuccess = false
        
        do {
            var updatedPhotoUrl = photoUrl
            
            // ✅ SUBIR IMAGEN SI HAY UNA NUEVA SELECCIONADA
            if let newImage = selectedImage {
                isUploadingImage = true
                
                // Eliminar foto vieja si existe
                if let oldUrl = photoUrl, !oldUrl.isEmpty {
                    try? await imagenUploadService.deleteProfileImage(imageURL: oldUrl)
                }
                
                // Subir nueva foto
                updatedPhotoUrl = try await imagenUploadService.uploadProfileImage(
                    userId: userId,
                    image: newImage
                )
                
                // ✅ ACTUALIZAR photoUrl LOCAL INMEDIATAMENTE
                photoUrl = updatedPhotoUrl
                
                isUploadingImage = false
                print("✅ Photo uploaded successfully: \(updatedPhotoUrl)")
            }
            
            let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
            
            // ✅ ACTUALIZAR USUARIO CON LA NUEVA URL
            try await profileUserService.updateUser(
                userId: userId,
                fullName: fullName.trimmingCharacters(in: .whitespaces),
                phone: trimmedPhone.isEmpty ? nil : trimmedPhone,
                photoUrl: updatedPhotoUrl
            )
            
            showSuccess = true
            print("✅ Profile updated successfully")
            
            // ✅ ACTUALIZAR originalUser CON NUEVA FOTO
            if var updatedUser = originalUser {
                updatedUser = User(
                    id: updatedUser.id,
                    fullName: fullName.trimmingCharacters(in: .whitespaces),
                    phone: trimmedPhone.isEmpty ? nil : trimmedPhone,
                    email: updatedUser.email,
                    photoUrl: updatedPhotoUrl, // ✅ USAR LA NUEVA URL
                    isActive: updatedUser.isActive,
                    createdAt: updatedUser.createdAt,
                    updatedAt: Date(),
                    rolId: updatedUser.rolId
                )
                originalUser = updatedUser
            }
            
            // ✅ LIMPIAR LA IMAGEN SELECCIONADA
            selectedImage = nil
            selectedPhotoItem = nil
            
        } catch {
            print("❌ Error saving profile: \(error)")
            errorMessage = error.localizedDescription
            showSuccess = false
            isUploadingImage = false
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
    
    ///funcion para manejar las selecion de imagen
    func handleImagenSelection(){
        Task{
            guard let photoItem = selectedPhotoItem else{ return}
            do{
                guard let imageData = try await photoItem.loadTransferable(type: Data.self),
                      let image = UIImage(data: imageData)else{
                    errorMessage = "Could not load image"
                    return
                }
                
                selectedImage = image
                print("image selected successfully")
            } catch {
                errorMessage = "error loading image: \(error.localizedDescription)"
                print(" Error loading image:\(error)")
            }
        }
    }
}
