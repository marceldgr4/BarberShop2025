import SwiftUI

struct MainTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var appointmentViewModel = AppointmentViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .environmentObject(homeViewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "list.bullet.below.rectangle")
            }
            
            NavigationStack {
                MapView()
            }
            .tabItem {
                Label("Map", systemImage: "network")
            }
            NavigationStack {
                AppointmentsView()
                    .environmentObject(appointmentViewModel)
            }
            .tabItem {
                Label("Bookings", systemImage: "calendar")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
        }
        .tint(Color(red: 238/255, green: 143/255, blue: 64/255)) // #EE8F40
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
