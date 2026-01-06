//
//  BookingConfirmationView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 1/01/26.
//

import SwiftUI

struct BookingConfirmationView: View {
    @ObservedObject var viewModel: BookingViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                    
                    Text("Review Your Booking")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Please confirm the details below")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                // Branch Info
                if let branch = viewModel.selectedBranch {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Location", systemImage: "building.2.fill")
                            .font(.headline)
                            .foregroundColor(.brandOrange)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(branch.name)
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(branch.address)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                // Barber Info
                if let barber = viewModel.selectedBarber {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Your Barber", systemImage: "person.fill")
                            .font(.headline)
                            .foregroundColor(.brandOrange)
                        
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
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(barber.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                
                                if let rating = barber.rating {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                        Text(String(format: "%.1f", rating))
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                // Services
                if !viewModel.selectedServices.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Services", systemImage: "scissors")
                            .font(.headline)
                            .foregroundColor(.brandOrange)
                        
                        VStack(spacing: 8) {
                            ForEach(viewModel.selectedServices) { service in
                                HStack {
                                    Text(service.name)
                                        .font(.body)
                                    Spacer()
                                    Text("$\(String(format: "%.0f", service.price))")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Date & Time
                VStack(alignment: .leading, spacing: 12) {
                    Label("Date & Time", systemImage: "calendar.circle.fill")
                        .font(.headline)
                        .foregroundColor(.brandOrange)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text(viewModel.selectedDate, style: .date)
                                .font(.body)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        if let time = viewModel.selectedTime {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.gray)
                                Text(time)
                                    .font(.body)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Notes
                if !viewModel.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Notes", systemImage: "note.text")
                            .font(.headline)
                            .foregroundColor(.brandOrange)
                        
                        Text(viewModel.notes)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                // Total
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Duration")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(viewModel.totalDuration) minutes")
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Total Price")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.0f", viewModel.totalPrice))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.brandOrange)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 30)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    BookingConfirmationView(viewModel: {
        let vm = BookingViewModel()
        vm.selectedBranch = Branch(
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
        vm.selectedServices = [
            Service(
                id: UUID(),
                categoryId: UUID(),
                name: "Corte",
                description: "Corte con máquina y tijera",
                durationMinutes: 30,
                price: 25000,
                imageUrl: nil,
                isActive: true,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
        vm.selectedDate = Date()
        vm.selectedTime = "10:00"
        vm.notes = "Por favor, corte clásico"
        return vm
    }())
}
