//
//  BranchDetailView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 16/12/25.
//

import SwiftUI
import MapKit

struct BranchDetailView: View {
    let branch: Branch
    @StateObject private var viewModel = BranchViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Image
                AsyncImage(url: URL(string: branch.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 200)
                .clipped()
                
                // MARK: - Info Section
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(branch.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.brandAccent)
                            .padding(.horizontal)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            Text(branch.address)
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.gray)
                            Text(branch.phone)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            if let email = branch.email {
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(Color.brandOrange)
                                    Text(email)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                // MARK: - Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        let coordinate = CLLocationCoordinate2D(
                            latitude: branch.latitude,
                            longitude: branch.longitude
                        )
                        let placemark = MKPlacemark(coordinate: coordinate)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = branch.name
                        mapItem.openInMaps(launchOptions: [
                            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                        ])
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                            Text("Direction")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandOrange)
                        .cornerRadius(50)
                    }
                    
                    Button(action: {
                        let phoneNumber = branch.phone.filter { $0.isNumber }
                        if let url = URL(string: "tel://\(phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandOrange)
                        .cornerRadius(50)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // MARK: - Map
                VStack(alignment: .leading, spacing: 12) {
                    Text("Location")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: branch.latitude,
                            longitude: branch.longitude
                        ),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )), annotationItems: [branch]) { branch in
                        MapMarker(coordinate: CLLocationCoordinate2D(
                            latitude: branch.latitude,
                            longitude: branch.longitude
                        ), tint: .red)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .allowsHitTesting(false)
                }
                
                Divider()
                
                // MARK: - Barbers Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Our Barbers")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if !viewModel.barbers.isEmpty {
                            NavigationLink(destination: BranchBarbersView(branch: branch)) {
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
                    
                    // Logic for Barbers List
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .tint(.brandOrange)
                            Spacer()
                        }
                        .padding()
                    } else if viewModel.barbers.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "person.3")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No barbers available")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.barbers.prefix(3)) { barber in
                                NavigationLink(destination: BarberDetailView(barber: barber)) {
                                    BarberRow(barber: barber)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                // MARK: - Booking Button
                NavigationLink(destination: Text("Booking view - coming soon")) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Book Appointment")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandGradient)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
            }
            .padding(.bottom, 30)
        }
        .navigationTitle(branch.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // ✅ FIX: Cambié selectedBranch por selectBranch
            await viewModel.selectBranch(branch)
        }
    }
}

#Preview {
    NavigationStack {
        BranchDetailView(
            branch: Branch(
                id: UUID(),
                name: "Center BarberShop",
                address: "calle 72 # 45-67, Barranquilla",
                latitude: 10.9878,
                longitude: -74.7889,
                phone: "+57 315 xxx xxxx",
                email: "Example@prueba.com",
                isActive: true,
                imageUrl: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        )
    }
}
