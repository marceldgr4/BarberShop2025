//
//  ImageUploadService.swift
//  BarberShop
//
//  Created by Marcel Diaz Granados Robayo on 9/02/26.
//

import Foundation
import Supabase
import UIKit

final class ImageUploadService{
    let client: SupabaseClient
    init(client: SupabaseClient = SupabaseManagerSecure.shared.client) {
        self.client = client
    }
    
    func uploadProfileImage(userId:UUID, image: UIImage) async throws -> String{
        guard let imageData = image.jpegData(compressionQuality: 0.7) else{
            throw ImageUploadError.invalidImage
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(userId.uuidString)_\(timestamp).jpg"
        let filePath = "profile_photo/\(fileName)"
        
        let uploadedPath = try await client.storage
            .from("avatars")
            .upload(
                filePath,
                data: imageData,
                    options: FileOptions( contentType:"image/jpeg" ,upsert:true))
        
        let publicURL = try client.storage
            .from("avatars")
            .getPublicURL(path: filePath)
        print("Image uploaded successfully: \(publicURL)")
        return publicURL.absoluteString
        
    }
    func deleteProfileImage(imageURL: String) async throws{
        guard let url = URL(string: imageURL),
              let pathComponents = url.pathComponents.split(separator: "avatars").last else{
            return
        }
        let path = pathComponents.joined(separator: "/")
        try await client.storage
            .from("avatars")
            .remove(paths: [path])
        print("Image deleted:\(path)")
    }
}

enum ImageUploadError: LocalizedError{
    case invalidImage
    case uploadFailed
    
    var errorDescription: String?{
        switch self{
        case .invalidImage:
            return "Could not process the image"
        case .uploadFailed:
            return "Failed to upload image"
        }
    }
}
