//
//  AppointmentsView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/12/25.
//

import SwiftUI

struct AppointmentsView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    @State private var showBooking = false
    
    var body: some View {
        ZStack{
            if viewModel.appointments.isEmpty && !viewModel.isLoading{
                VStack(spacing: 20){
                    Image(systemName: "calendar.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80,height: 80)
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No appointment Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("book your first appointment to get started" )
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        showBooking = true
                    }){
                        HStack{
                            Image(systemName: "plus.circle.fill")
                            Text("Book appointment")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brandGradient)
                        .cornerRadius(50)
                    }
                    .padding(.top)
                }
                .padding()
            }
            //MARK: Appointment List
            else if !viewModel.appointments.isEmpty {
                List{
                    ForEach(viewModel.appointments) { appointment in
                        AppointmentRow(appointment: appointment)
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await viewModel.loadAppointments()
                }
                
            }
            if viewModel.isLoading{
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing:15){
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("Loading appointments...")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
        }
        .navigationTitle("My Appointments")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    showBooking = true
                }){
                    Image(systemName: "plus")
                        .foregroundColor(Color.brandOrange)
                }
            }
        }
        .sheet(isPresented: $showBooking){
            BookingFlowView()
        }
        .task {
            await viewModel.loadAppointments()
        }
        .onAppear{
            Task{
                await viewModel.loadAppointments()
            }
        }
        .alert("ERROR",isPresented: .constant(viewModel.errorMessage != nil)){
            Button("OK"){
                viewModel.errorMessage = nil
            }
            Button("Retry"){
                Task{
                    await viewModel.loadAppointments()
                }
            }
        } message: {
            if let error = viewModel.errorMessage{
                Text(error)
            }
        }
    }
}

#Preview {
    NavigationStack{
        AppointmentsView().environmentObject(AuthViewModel())
    }
}
