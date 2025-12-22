import SwiftUI
import MapKit
import Combine
import CoreLocation

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var cityName: String = "Finding Location..."
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            cityName = "Location Disabled"
        case .notDetermined:
            cityName = "Allow Location"
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        userLocation = latestLocation.coordinate
        manager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(latestLocation) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                self.cityName = "Geolocation error"
                return
            }
            
            if let city = placemarks?.first?.locality {
                self.cityName = city
            } else if let country = placemarks?.first?.country {
                self.cityName = country
            } else {
                self.cityName = "Unknown place"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error.localizedDescription)")
        cityName = "GPS failed"
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var currentPromoIndex = 0
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header & Location
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Location")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.brandOrange)
                                    .imageScale(.small)
                                Text(locationManager.cityName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        // Notifications Button
                        Button(action: {
                            // TODO: Navigate to notifications
                        }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                                
                                // Badge for unread notifications
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: -2, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .imageScale(.medium)
                        
                        TextField("Search services, barbers...", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // MARK: - Map with Branches
                    if !viewModel.branches.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.brandOrange)
                                    .imageScale(.medium)
                                Text("Our Locations")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
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
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                            
                            // Selected Branch Card
                            if let selectedBranch = viewModel.selectedBranch {
                                NavigationLink(destination: BranchDetailView(branch: selectedBranch)) {
                                    BranchRowItem(branch: selectedBranch)
                                        .padding(.horizontal)
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                    }
                    
                    // MARK: - Promotions Carousel
                    if !viewModel.promotions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.brandOrange)
                                    .imageScale(.medium)
                                Text("Special Offers")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: PromotionsListView(promotions: viewModel.promotions)) {
                                    HStack(spacing: 4) {
                                        Text("See All")
                                            .font(.subheadline)
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                    }
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
                                        .scaleEffect(currentPromoIndex == index ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.3), value: currentPromoIndex)
                                        .onTapGesture {
                                            withAnimation {
                                                currentPromoIndex = index
                                            }
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 5)
                        }
                    }
                    
                    // MARK: - Services Section
                    if !viewModel.services.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "scissors")
                                    .foregroundColor(.brandOrange)
                                    .imageScale(.medium)
                                Text("Our Services")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: ServicesListView(services: viewModel.services)) {
                                    HStack(spacing: 4) {
                                        Text("See All")
                                            .font(.subheadline)
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                    }
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
                                    .imageScale(.medium)
                                Text("Top Rated Barbers")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: BarbersListView(barbers: viewModel.featuredBarbers)) {
                                    HStack(spacing: 4) {
                                        Text("See All")
                                            .font(.subheadline)
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                    }
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
                .padding(.top, 10)
            }
            .refreshable {
                await viewModel.loadHomeData()
            }
            
            // MARK: - Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .brandOrange))
                        .scaleEffect(1.5)
                    
                    Text("Loading amazing services...")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: viewModel.isLoading)
        .animation(.easeInOut, value: viewModel.selectedBranch)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.branches.isEmpty {
                await viewModel.loadHomeData()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
            Button("Retry") {
                Task {
                    await viewModel.loadHomeData()
                }
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unexpected error occurred")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
