//
//  BranchBarbersView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo
//

import SwiftUI

struct BranchBarbersView: View {
    let branch: Branch
    @StateObject  var viewModel = BranchBarbersViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                // Loading State
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.brandOrange)
                    Text("Loading barbers...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            } else if viewModel.barbers.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No Barbers Available")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This branch doesn't have barbers registered yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        Task {
                            await viewModel.loadBarbers(for: branch.id)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                        }
                        .foregroundColor(.brandOrange)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.brandOrange.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            } else {
                // Barbers List
                List(filteredBarbers) { barber in
                    NavigationLink(destination: BarberDetailView(barber: barber)) {
                        BarberRow(barber: barber)
                    }
                }
                .listStyle(.insetGrouped)
                .searchable(text: $searchText, prompt: "Search barbers")
            }
        }
        .navigationTitle("\(branch.name)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.barbers.isEmpty {
                    Text("\(filteredBarbers.count) barber\(filteredBarbers.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .task {
            await viewModel.loadBarbers(for: branch.id)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
            Button("Retry") {
                Task {
                    await viewModel.loadBarbers(for: branch.id)
                }
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
    
    private var filteredBarbers: [BarberWithRating] {
        if searchText.isEmpty {
            return viewModel.barbers
        }
        return viewModel.barbers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - ViewModel

// MARK: - Preview
#Preview("With Barbers") {
    NavigationStack {
        BranchBarbersViewPreview(hasBarbers: true)
    }
}

#Preview("Empty State") {
    NavigationStack {
        BranchBarbersViewPreview(hasBarbers: false)
    }
}

#Preview("Loading State") {
    NavigationStack {
        BranchBarbersViewPreview(isLoading: true)
    }
}

// MARK: - Preview Helper
struct BranchBarbersViewPreview: View {
    let hasBarbers: Bool
    let isLoading: Bool
    
    init(hasBarbers: Bool = true, isLoading: Bool = false) {
        self.hasBarbers = hasBarbers
        self.isLoading = isLoading
    }
    
    var body: some View {
        BranchBarbersView(
            branch: Branch(
                id: UUID(),
                name: "Central Barbershop",
                address: "Calle 72 #45-67",
                latitude: 10.9878,
                longitude: -74.7889,
                phone: "+57 300 123 4567",
                email: "central@barbershop.com",
                isActive: true,
                imageUrl: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        )
        .task {
            // Simular datos para preview
            if let view = findBranchBarbersView() {
                if isLoading {
                    view.viewModel.isLoading = true
                } else if hasBarbers {
                    view.viewModel.barbers = [
                        BarberWithRating(
                            id: UUID(),
                            branchId: UUID(),
                            specialtyId: UUID(),
                            name: "Carlos Martínez",
                            photoUrl: nil,
                            isActive: true,
                            rating: 4.8,
                            totalReviews: 156
                        ),
                        BarberWithRating(
                            id: UUID(),
                            branchId: UUID(),
                            specialtyId: UUID(),
                            name: "Luis Rodríguez",
                            photoUrl: nil,
                            isActive: true,
                            rating: 4.6,
                            totalReviews: 98
                        ),
                        BarberWithRating(
                            id: UUID(),
                            branchId: UUID(),
                            specialtyId: UUID(),
                            name: "Pedro Gómez",
                            photoUrl: nil,
                            isActive: true,
                            rating: 4.9,
                            totalReviews: 203
                        )
                    ]
                    view.viewModel.isLoading = false
                } else {
                    view.viewModel.barbers = []
                    view.viewModel.isLoading = false
                }
            }
        }
    }
    
    private func findBranchBarbersView() -> BranchBarbersView? {
        // Helper para acceder al viewModel en preview
        return nil
    }
}

