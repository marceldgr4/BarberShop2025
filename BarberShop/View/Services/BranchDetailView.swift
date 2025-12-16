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
                // Image
                AsyncImage(url: URL(string: branch.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 200)
                .clipped()
                
                // Info
                VStack(alignment: .leading, spacing: 12) {
                    Text(branch.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(branch.phone)
                        
                        Spacer()
                        
                        if let email = branch.email {
                            Image(systemName: "envelope.fill")
                            Text(email)
                                .lineLimit(1)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                // Map
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
                
                // Barbers
                VStack(alignment: .leading, spacing: 12) {
                    Text("Our Barbers")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.barbers) { barber in
                        BarberRow(barber: barber)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle(branch.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.selectBranch(branch)
        }
    }
}

#Preview {
    BranchDetailView(branch: Branch(id: UUID(),
                                    name: "Center BarberShop",
                                    address: "calle 72 # 45-67, Barraquilla",
                                    latitude: 10.9878,
                                    longitude: -74.7889,
                                    phone: "+57 315 xxx xxxx",
                                    email: "Exmple@prueba.com",
                                    isActive: true,
                                    imageUrl: nil,
                                    createdAt: Date(),
                                    updatedAt: Date()
                                   )
                     )
}
