import SwiftUI
import MapKit
import CoreLocation
import Combine

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var cityName: String = "Finding Location..."
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocationCoordinate2D?
   
    

    private let manager = CLLocationManager()
    
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
            if let city = placemarks?.first?.locality {
                self.cityName = city
            } else if let country = placemarks?.first?.country {
                self.cityName = country
            } else {
                self.cityName = "Current Location"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityName = "Location Unavailable"
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
                        
                        Button(action: {}) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                                
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
                    
                    // MARK: - Map Section (SIEMPRE VISIBLE)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.brandOrange)
                            Text("Our Locations")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.branches.isEmpty {
                            // Con datos reales
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
                            .shadow(color: .black.opacity(0.1), radius: 5)
                            .padding(.horizontal)
                            
                            if let selectedBranch = viewModel.selectedBranch {
                                NavigationLink(destination: BranchDetailView(branch: selectedBranch)) {
                                    BranchRowItem(branch: selectedBranch)
                                        .padding(.horizontal)
                                }
                            }
                        } else {
                            // Placeholder cuando no hay datos
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 200)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "map")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .tint(.brandOrange)
                                        Text("Loading locations...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("No locations available")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Button("Refresh") {
                                            Task {
                                                await viewModel.loadHomeData()
                                            }
                                        }
                                        .font(.caption)
                                        .foregroundColor(.brandOrange)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Promotions Section (SIEMPRE VISIBLE)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.brandOrange)
                            Text("Special Offers")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            if !viewModel.promotions.isEmpty {
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
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.promotions.isEmpty {
                            // Con datos reales
                            TabView(selection: $currentPromoIndex) {
                                ForEach(Array(viewModel.promotions.enumerated()), id: \.element.id) { index, promotion in
                                    PromotionCard(promotion: promotion)
                                        .padding(.horizontal, 8)
                                        .tag(index)
                                }
                            }
                            .frame(height: 180)
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            
                            HStack(spacing: 8) {
                                ForEach(0..<viewModel.promotions.count, id: \.self) { index in
                                    Circle()
                                        .fill(currentPromoIndex == index ? Color.brandOrange : Color.gray.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(currentPromoIndex == index ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.3), value: currentPromoIndex)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            // Placeholder cards
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(0..<3) { _ in
                                        PlaceholderPromotionCard(isLoading: viewModel.isLoading)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // MARK: - Services Section (SIEMPRE VISIBLE)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "scissors")
                                .foregroundColor(.brandOrange)
                            Text("Our Services")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            if !viewModel.services.isEmpty {
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
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if !viewModel.services.isEmpty {
                                    // Con datos reales
                                    ForEach(viewModel.services.prefix(6)) { service in
                                        NavigationLink(destination: ServiceDetailView(service: service)) {
                                            ServiceCard(service: service)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                } else {
                                    // Placeholder cards
                                    ForEach(0..<4) { _ in
                                        PlaceholderServiceCard(isLoading: viewModel.isLoading)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Barbers Section (SIEMPRE VISIBLE)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.brandOrange)
                            Text("Top Rated Barbers")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            if !viewModel.featuredBarbers.isEmpty {
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
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if !viewModel.featuredBarbers.isEmpty {
                                    // Con datos reales
                                    ForEach(viewModel.featuredBarbers.prefix(6)) { barber in
                                        NavigationLink(destination: BarberDetailView(barber: barber)) {
                                            BarberCard(barber: barber)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                } else {
                                    // Placeholder cards
                                    ForEach(0..<4) { _ in
                                        PlaceholderBarberCard(isLoading: viewModel.isLoading)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding(.top, 10)
            }
            .refreshable {
                await viewModel.loadHomeData()
            }
            
            // MARK: - Error Overlay (solo si hay error)
            if let error = viewModel.errorMessage, !viewModel.isLoading {
                VStack(spacing: 20) {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadHomeData()
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.brandOrange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .padding()
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: viewModel.errorMessage)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.branches.isEmpty && !viewModel.isLoading {
                await viewModel.loadHomeData()
            }
        }
    }
}

// MARK: - Placeholder Components

struct PlaceholderPromotionCard: View {
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
                .frame(width: 280, height: 160)
            
            VStack(spacing: 12) {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                if isLoading {
                    ProgressView()
                        .tint(.brandOrange)
                } else {
                    Text("No promotions")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct PlaceholderServiceCard: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(width: 160, height: 120)
                .overlay(
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.brandOrange)
                        } else {
                            Image(systemName: "scissors")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(isLoading ? "Loading..." : "No services")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("--")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("-- min")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
    }
}

struct PlaceholderBarberCard: View {
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
                .frame(width: 100, height: 100)
                .overlay(
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.brandOrange)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                    }
                )
            
            Text(isLoading ? "Loading..." : "No barbers")
                .font(.headline)
                .foregroundColor(.gray)
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("--")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 140)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
