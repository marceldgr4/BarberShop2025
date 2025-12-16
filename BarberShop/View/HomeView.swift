/*
import Combine
import CoreLocation
import SwiftUI

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
        case .authorizedWhenInUse, .authorizedAlways: manager.startUpdatingLocation()
        case .denied, .restricted: cityName = "Location Disabled"
        case .notDetermined: cityName = "Allow Location"
        default: break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        manager.stopUpdatingLocation()

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(latestLocation) {
            [weak self] placemarks, error in

            guard let self = self else { return }

            if let error = error {
                print("Reverse geocoding erro: \(error.localizedDescription)")
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
struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var currentPage = 0

    // Inyectamos el ViewModel
    var viewModel: HomeViewModel

    // Obtenemos los datos del ViewModel en lugar de los mocks directos
    var services: [Service] { viewModel.services }
    var nearbyBarbers: [Barber] { viewModel.nearbyBarbers }

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
                                    .foregroundColor(Color(hex: "#EE8F40"))  // Color naranja
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
                        Image(systemName: "magnifyingglass")  // Corregido: magnifyingglass
                            .foregroundColor(.gray)
                        TextField("Search BarberShop", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // MARK: - Special for you (Carousel)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("#Special for you")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink("See All", destination: SpecialOffersView())
                                .foregroundColor(Color(hex: "#EE8F40"))
                                .font(.subheadline)
                        }
                        .padding(.horizontal)

                        // Carrusel
                        TabView(selection: $currentPage) {
                            ForEach(0..<3, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 150)
                                    .padding(.horizontal)
                                    .overlay(
                                        Text("Special Offer \(index + 1)")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)

                                    )
                                    .tag(index)
                            }
                        }
                        .frame(height: 160)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                        // Indicadores del carrusel
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(
                                        currentPage == index
                                            ? Color(hex: "#EE8F40") : Color.gray.opacity(0.4)
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

                    // MARK: - Services Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Services")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(
                                "See All", destination: ServicesListView(services: services)
                            )
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#EE8F40"))
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                // Iterando sobre los datos mockeados de Service
                                ForEach(services) { service in
                                    ServiceItem(service: service)
                                        .font(.caption)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 15)
                                        //.background(Color(.systemGray5))
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: - Nearby Barbers Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Barbers")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(
                                "See All", destination: BarberListView(barbers: nearbyBarbers)
                            )
                            .foregroundColor(Color(hex: "#EE8F40"))
                            .font(.subheadline)
                        }
                        .padding(.horizontal)  // Aplicado aquí para consistencia

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                // Corregido: Iterar sobre los datos mockeados de Barber
                                ForEach(nearbyBarbers) { barber in
                                    BarberCard(barber: barber)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
*/
