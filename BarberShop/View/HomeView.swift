import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var currentPromoIndex = 0
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Find Your Style")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Book your next appointment")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search BarberShop or Service", text: $searchText)
                            .textInputAutocapitalization(.never)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // MARK: - Map with Branches
                    if !viewModel.branches.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.brandOrange)
                                Text("Our Locations")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            
                            Map(coordinateRegion: $viewModel.mapRegion,
                                annotationItems: viewModel.branches) { branch in
                                MapAnnotation(coordinate: CLLocationCoordinate2D(
                                    latitude: branch.latitude,
                                    longitude: branch.longitude
                                )) {
                                    BranchMapMarker(branch: branch) {
                                        viewModel.selectBranch(branch)
                                    }
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(15)
                            .padding(.horizontal)
                            
                            // Selected Branch Card (if any)
                            if let selectedBranch = viewModel.selectedBranch {
                                NavigationLink(destination: BranchDetailView(branch: selectedBranch)) {
                                    BranchRowItem(branch: selectedBranch)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Promotion Carousel
                    if !viewModel.promotions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.brandOrange)
                                Text("Special Offers")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                
                                NavigationLink(destination: PromotionsListView(promotions: viewModel.promotions)) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(.brandOrange)
                                }
                            }
                            .padding(.horizontal)
                            
                            TabView(selection: $currentPromoIndex) {
                                ForEach(Array(viewModel.promotions.enumerated()), id: \.element.id) { index, promotion in
                                    PromotionCard(promotion: promotion)
                                        .padding(.horizontal, 8)
                                        .tag(index)
                                }
                            }
                            .frame(height: 180)
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            
                            // Custom Page Indicators
                            HStack(spacing: 8) {
                                ForEach(0..<viewModel.promotions.count, id: \.self) { index in
                                    Circle()
                                        .fill(currentPromoIndex == index ? Color.brandOrange : Color.gray.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                        .animation(.spring(response: 0.3), value: currentPromoIndex)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // MARK: - Services Section
                    if !viewModel.services.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "scissors")
                                    .foregroundColor(.brandOrange)
                                Text("Our Services")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                
                                NavigationLink(destination: ServicesListView(services: viewModel.services)) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(.brandOrange)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.services.prefix(6)) { service in
                                        NavigationLink(destination: ServiceDetailView(service: service)) {
                                            ServiceCard(service: service)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // MARK: - Top Rated Barbers
                    if !viewModel.featuredBarbers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.brandOrange)
                                Text("Top Rated Barbers")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                
                                NavigationLink(destination: BarbersListView(barbers: viewModel.featuredBarbers)) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(.brandOrange)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.featuredBarbers.prefix(6)) { barber in
                                        NavigationLink(destination: BarberDetailView(barber: barber)) {
                                            BarberCard(barber: barber)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer(minLength: 30)
                }
            }
            .refreshable {
                await viewModel.loadHomeData()
            }
            
            // MARK: - Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .brandOrange))
                        .scaleEffect(1.5)
                    
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.branches.isEmpty {
                await viewModel.loadHomeData()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
