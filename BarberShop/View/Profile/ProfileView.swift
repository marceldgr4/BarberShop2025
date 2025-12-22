//
//  ProfileView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutAlert = false
    
    var body: some View {
        List{
            Section{
                HStack(spacing: 15){
                    AsyncImage(url: URL(string: viewModel.user?.photoUrl ?? "")){
                        image in image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(Color.orange)
                        
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    if let user = viewModel.user{
                        VStack(alignment: .leading, spacing: 5){
                            Text(user.fullName)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            if let email = user.email {
                                Text(email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            if let phone = user.phone{
                                Text(phone)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }else{
                        VStack(alignment: .leading, spacing: 5){
                            Text("Loading...")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.vertical,10)
            }
            Section("My Activity"){
                NavigationLink(destination: FavoriteBarbersView(barbers: viewModel.favoriteBarbers)){
                    HStack{
                        Label("Favorite barbers", systemImage: "heart")
                        Spacer()
                        if !viewModel.favoriteBarbers.isEmpty{
                            Text("\(viewModel.favoriteBarbers.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal,8)
                                .padding(.vertical,2)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            Section("Settings"){
                NavigationLink(destination: EditProfileView(user: viewModel.user)){
                    Label("Edit Profile", systemImage: "person.circle")
                }
                NavigationLink(destination: NotificationsSettingsView()){
                    Label("Notifications",systemImage: "bell")
                }
                NavigationLink(destination: PrivacySettingsView()){
                    Label("Privacy", systemImage: "lock.shield")
                }
            }
            Section("Support"){
                Link(destination: URL(string: "mailto:support@barberShop.com")!){
                    Label("Contact Support", systemImage: "envelope")
                }
                NavigationLink(destination: AboutView()){
                    Label("About", systemImage: "info.circle")
                }
            }
            //MARK: Logout
            Section{
                Button(action: {
                    showLogoutAlert = true
                }){
                    HStack{
                        Spacer()
                        Label("Sing Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task{
            if viewModel.user == nil{
                await viewModel.loadProfile()
            }
                
        }
        .refreshable {
            await viewModel.loadProfile()
        }
        .alert("Sign Out", isPresented: $showLogoutAlert){
            Button("Cancel", role: .cancel){}
            Button("Sign Out", role: .destructive){
                Task{
                    await authViewModel.signOut()
                }
            }
            
        } message: {
                Text("are you sure you want to sugn out?")
            }
        
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK"){
                viewModel.errorMessage = nil
                
            }
        } message:{
            if let error = viewModel.errorMessage{
                Text(error)
            }
        }
    }
}

    
#Preview {
    NavigationStack{
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}

