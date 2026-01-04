//
//  SelectServiceView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 1/01/26.
//

import SwiftUI

struct SelectServiceView: View {
    @ObservedObject var viewModel: BookingViewModel
    @State private var searchText = ""
    
    var filteredServices: [Service] {
        if searchText.isEmpty {
            return viewModel.services
        }
        return viewModel.services.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            // Selected Barber Info
            if let barber = viewModel.selectedBarber {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: barber.photoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.brandOrange.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.brandOrange)
                            )
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(barber.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        if let rating = barber.rating {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                                Text(String(format: "%.1f", rating))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search services...", text: $searchText)
                    .textInputAutocapitalization(.never)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
            
            // Services List
            if filteredServices.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "scissors")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No services available")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredServices) { service in
                            ServiceItem(
                                service: service,
                                isSelected: viewModel.isServiceSelected(service),
                                active: {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.toogleService(service)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // Total Price Bar
                if !viewModel.selectedServices.isEmpty {
                    VStack(spacing: 8) {
                        HStack {
                            Text("\(viewModel.selectedServices.count) service(s) selected")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Total: $\(String(format: "%.0f", viewModel.totalPrice))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.brandOrange)
                        }
                        
                        Text("Duration: \(viewModel.totalDuration) min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    SelectServiceView(viewModel: {
        let vm = BookingViewModel()
        vm.selectedBarber = BarberWithRating(
            id: UUID(),
            branchId: UUID(),
            specialtyId: UUID(),
            name: "Carlos Martínez",
            photoUrl: nil,
            isActive: true,
            rating: 4.8,
            totalReviews: 156
        )
        return vm
    }())
}
