//
//  MapView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedBranch: Branch?
    @State private var showBranchDetail = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Map
            if !viewModel.branches.isEmpty {
                Map(coordinateRegion: $viewModel.region,
                    annotationItems: viewModel.branches.filter {
                        $0.latitude.isFinite && $0.longitude.isFinite
                    }) { branch in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: branch.latitude,
                        longitude: branch.longitude
                    )) {
                        BranchMapMarker(branch: branch) {
                            Task { @MainActor in
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectBranch(branch)
                                    selectedBranch = branch
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            } else {
                // Placeholder cuando no hay datos
                ZStack {
                    Color(.systemGray6)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.brandOrange)
                            Text("Loading map...")
                                .foregroundColor(.gray)
                        } else {
                            Text("No locations available")
                                .font(.title3)
                                .foregroundColor(.gray)
                            
                            Button("Retry") {
                                Task {
                                    await viewModel.loadBranches()
                                }
                            }
                            .foregroundColor(.brandOrange)
                        }
                    }
                }
            }
            
            // MARK: - Top Controls
            VStack {
                HStack {
                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search branches...", text: $viewModel.searchText)
                            .textInputAutocapitalization(.never)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    // Recenter Button
                    Button(action: {
                        withAnimation {
                            viewModel.recenterMap()
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.brandOrange)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            
            // MARK: - Branch Card (cuando se selecciona)
            if let branch = selectedBranch {
                VStack(spacing: 0) {
                    // Drag Indicator
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            // Image
                            if let imageUrl = branch.imageUrl, !imageUrl.isEmpty {
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .overlay(
                                            Image(systemName: "building.2")
                                                .font(.system(size: 40))
                                                .foregroundColor(.blue)
                                        )
                                }
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.3))
                                    .overlay(
                                        Image(systemName: "building.2")
                                            .font(.system(size: 40))
                                            .foregroundColor(.blue)
                                    )
                                    .frame(height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Info
                            VStack(alignment: .leading, spacing: 8) {
                                Text(branch.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                    Text(branch.address)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.blue)
                                    Text(branch.phone)
                                        .font(.subheadline)
                                }
                                
                                if let email = branch.email {
                                    HStack(spacing: 8) {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.blue)
                                        Text(email)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            
                            // Action Buttons
                            HStack(spacing: 12) {
                                // Directions
                                Button(action: {
                                    guard branch.latitude.isFinite && branch.longitude.isFinite else {
                                        return
                                    }
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
                                        Text("Directions")
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                                
                                // Call
                                Button(action: {
                                    let phoneNumber = branch.phone.filter { $0.isNumber }
                                    guard !phoneNumber.isEmpty,
                                          let url = URL(string: "tel://\(phoneNumber)") else {
                                        return
                                    }
                                    UIApplication.shared.open(url)
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
                                    .background(Color.green)
                                    .cornerRadius(10)
                                }
                            }
                            
                            // View Details Button
                            NavigationLink(destination: BranchDetailView(branch: branch)) {
                                HStack {
                                    Text("View Full Details")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandGradient)
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 400)
                }
                .background(.ultraThinMaterial)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
                .transition(.move(edge: .bottom))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height > 50 {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedBranch = nil
                                }
                            }
                        }
                )
            }
            
            // MARK: - Loading Overlay
            if viewModel.isLoading && !viewModel.branches.isEmpty {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("Loading branches...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
        }
        .navigationTitle("Locations Map")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadBranches()
        }
    }
}



// MARK: - Preview
#Preview {
    NavigationStack {
        MapView()
    }
}


