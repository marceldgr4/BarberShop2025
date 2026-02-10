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
    @State private var refreshID = UUID()  // ✅ Para forzar recarga

    var body: some View {
        List {
            // MARK: - User Info Section
            Section {
                HStack(spacing: 15) {
                    AsyncImage(url: URL(string: viewModel.user?.photoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(Color.orange)
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                    if let user = viewModel.user {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(user.fullName)
                                .font(.title3)
                                .fontWeight(.semibold)

                            if let email = user.email {
                                Text(email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            if let phone = user.phone {
                                Text(phone)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Loading...")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.vertical, 10)
            }

            // MARK: - My Activity Section
            Section("My Activity") {
                NavigationLink(destination: FavoriteBarbersView(barbers: viewModel.favoriteBarbers))
                {
                    HStack {
                        Label("Favorite barbers", systemImage: "heart")
                        Spacer()
                        if !viewModel.favoriteBarbers.isEmpty {
                            Text("\(viewModel.favoriteBarbers.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            // MARK: - Settings Section
            Section("Settings") {
                NavigationLink(destination: EditProfileView(user: viewModel.user)) {
                    Label("Edit Profile", systemImage: "person.circle")
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        // Cuando regrese de EditProfileView, recargar el perfil
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000)  // Pequeño delay
                            await viewModel.loadProfile()
                        }
                    })

                NavigationLink(destination: NotificationsSettingsView()) {
                    Label("Notifications", systemImage: "bell")
                }
                NavigationLink(destination: PrivacySettingsView()) {
                    Label("Privacy", systemImage: "lock.shield")
                }
            }

            // MARK: - Support Section
            Section("Support") {
                Link(destination: URL(string: "mailto:support@barberShop.com")!) {
                    Label("Contact Support", systemImage: "envelope")
                }

                NavigationLink(destination: AboutView()) {
                    Label("About", systemImage: "info.circle")
                }
            }

            // MARK: - Logout Section
            Section {
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Spacer()
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: refreshID) {  //  Recarga cuando cambia refreshID
            if viewModel.user == nil {
                await viewModel.loadProfile()
            }
        }
        .refreshable {
            await viewModel.loadProfile()
        }

        // MARK: - Alerts
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                Task {
                    await authViewModel.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }

        .alert(
            "Error",
            isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
