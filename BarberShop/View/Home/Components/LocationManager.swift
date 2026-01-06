//
//  LocationManager.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
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
    
    func locationManagerDidChangeAuthorization (_ manager: CLLocationManager){
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus{
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            cityName = "Location Disable"
        case .notDetermined:
            cityName = "Allow Location"
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let latestLocation = locations.first else{ return }
        
        Task{ @MainActor in
            self.userLocation = latestLocation.coordinate
        }
        manager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(latestLocation){ [weak self] placamarks, error in
            guard let self = self else {return}
            Task {@MainActor in
                if let city = placamarks?.first?.locality{
                    self.cityName = city
                }else if let country = placamarks?.first?.country{
                    self.cityName = country
                }else{
                    self.cityName = "Current Location"
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location error: \(error.localizedDescription)")
        cityName = "Locarion Unavailable"
    }
    
}
