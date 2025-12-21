import SwiftUI
import MapKit
import Combine
import CoreLocation

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var cityName: String = "Finding Location..."
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        manager.delegate = self
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
    @State private var currentPage = 0
    
    var body: some View {
        NavigationStack {
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
                                    .foregroundColor(Color(hex: "#EE8F40"))
                                Text(locationManager.cityName)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search BarberShop", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // MARK: - Map with Branches
                    if !viewModel.branches.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
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
                            .padding(.horizontal)
                            
                            if let selectedBranch = viewModel.selectedBranch {
                                NavigationLink(destination: BranchDetailView(branch: selectedBranch)) {
                                    BranchRowItem(branch: selectedBranch)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    // MARK: - Special for you (Carousel)
                    if !viewModel.promotions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("#Special for you")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: PromotionsListView(promotions: viewModel.promotions)) {
                                    Text("See All")
                                        .foregroundColor(Color(hex: "#EE8F40"))
                                        .font(.subheadline)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Carrusel
                            TabView(selection: $currentPage) {
                                ForEach(Array(viewModel.promotions.enumerated()), id: \.element.id) { index, promotion in
                                    PromotionCard(promotion: promotion)
                                        .padding(.horizontal)
                                        .tag(index)
                                }
                            }
                            .frame(height: 160)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                            // Indicadores del carrusel
                            HStack(spacing: 8) {
                                ForEach(0..<viewModel.promotions.count, id: \.self) { index in
                                    Circle()
                                        .fill(
                                            currentPage == index
                                                ? Color(hex: "#EE8F40")
                                                : Color.gray.opacity(0.4)
                                        )
                                        .frame(width: 8, height: 8)
                                        .onTapGesture {
                                            withAnimation {
                                                currentPage = index
                                            }
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // MARK: - Services Section
                    if !viewModel.services.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Services")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: ServicesListView(services: viewModel.services)) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "#EE8F40"))
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
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
                    
                    // MARK: - Barbers Section
                    if !viewModel.featuredBarbers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Barbers")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink(destination: BarbersListView(barbers: viewModel.featuredBarbers)) {
                                    Text("See All")
                                        .foregroundColor(Color(hex: "#EE8F40"))
                                        .font(.subheadline)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 18) {
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
                .padding(.top)
            }
            .refreshable {
                await viewModel.loadHomeData()
            }
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 15) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#EE8F40")))
                            .scaleEffect(1.5)
                        
                        Text("Loading...")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
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
}


#Preview {
    NavigationStack {
        HomeView()
    }
}
