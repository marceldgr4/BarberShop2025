import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var notificationService = NotificationService.shared
    
    @State private var searchText = ""
    @State private var showNotifications = false
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 20){
                    
                    HomeHeaderView(
                        locationManager: locationManager,
                        unreadCount: notificationService.unreadCount
                    ){
                        showNotifications = true
                        print("Notification tapped")
                    }
                    HomeSearchBarView(text: $searchText)
                    
                    HomeMapSectionView(viewModel: viewModel)
                    
                    HomePromotionsSectionView(promotions: viewModel.promotions, isLoading: viewModel.isLoading)
                    
                    HomeServiceSectionView(services: viewModel.services, isLoading: viewModel.isLoading)
                    
                    HomeBarberSectionView(barbers: viewModel.featuredBarbers, isLoading: viewModel.isLoading)
                    
                    Spacer(minLength: 30)
                }
                .padding(.bottom,20)
            }
            .refreshable {
                await viewModel.loadHomeData()
            }
            if let error = viewModel.errorMessage, !viewModel.isLoading{
                ErrorOverlayView(error: error){
                    Task{
                        await viewModel.loadHomeData()}
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showNotifications){
            NotificationView()
        }
        .task {
            if viewModel.branches.isEmpty && !viewModel.isLoading{
                await viewModel.loadHomeData()
            }
        }
    }
}
#Preview {
    NavigationStack{
        HomeView()
    }
}
