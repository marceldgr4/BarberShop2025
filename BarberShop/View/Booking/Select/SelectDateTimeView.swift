//
//  SelectDateTimeView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 3/01/26.
//

import SwiftUI

struct SelectDateTimeView: View {
    @ObservedObject var  viewModel: BookingViewModel
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading, spacing: 20){
                VStack(alignment: .leading, spacing: 12){
                    Label("Select Date", systemImage: "calendar")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    DatePicker(
                        "Date",
                               selection: $viewModel.selectedDate,
                               in: Date()...,
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(.brandOrange)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
                
                VStack(alignment:.leading, spacing: 12){
                    Label("Select time", systemImage: "clock")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if viewModel.availableTimeSlots.isEmpty{
                        HStack{
                            Spacer()
                            ProfileView()
                                .tint(.brandOrange)
                            Text("Loading Times...")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                    } else{
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12){
                            ForEach(viewModel.availableTimeSlots, id: \.self) {
                                timeSlot in
                                Button(action:{
                                    withAnimation(.spring(response: 0.3)){
                                        viewModel.selectedTime = timeSlot
                                    }
                                }) {
                                    Text(timeSlot)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.selectedTime == timeSlot ? .white: .primary)
                                        .padding()
                                        .background(
                                            viewModel.selectedTime == timeSlot ? Color.brandOrange:
                                                Color(.systemGray6)
                                        )
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12){
                    Label("Additional Notes (Optional)", systemImage: "note.text")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2),lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                Spacer(minLength: 30)
            }
            .padding(.vertical)
        }
        
    }
}

#Preview {
    SelectDateTimeView(viewModel: {
        let vm = BookingViewModel()
        vm.availableTimeSlots = ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30"]
        return vm
    }())
}
