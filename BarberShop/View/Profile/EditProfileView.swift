//
//  EditProfileView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct EditProfileView: View {
    let user: User?
    var body: some View {
        Form {
            Section("Personal Information"){
                if let user = user{
                    Text("Name: \(user.fullName)")
                    if let email = user.email{
                        Text("email:\(email)")
                    }
                    if let phone = user.phone{
                        Text("Phone: \(phone)")
                    }
                }else{
                    Text("Loading")
                }
            }
        }
        .navigationTitle("Edit Profile")
    }
}

#Preview {
    EditProfileView(user: User(id: UUID(),
                               fullName: "marcel",
                               phone: "42423",
                               email: "prueba@gmail.com",
                               photoUrl: nil,
                               isActive: true,
                               createdAt: Date(),
                               updatedAt: Date()))
}
