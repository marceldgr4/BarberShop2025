//
//  ScheduleCalendarView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 14/01/26.
//

import SwiftUI

struct ScheduleCalendarView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedView: ViewType = .calendar
    
    enum ViewType {
        case calendar, availability, settings
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                if let barber = viewModel.selectedBarber{
                    BarberInfoHeader(barber: barber)
                }
                else{
                    BarberSelectorView{ barber in viewModel.selectedBarber(barber)}
                }
            }
            Picker("View", selection: $selectedView){
                Text("Calendar").tag(ViewType.calendar)
                Text("Availability").tag(ViewType.availability)
                Text("Settings").tag(ViewType.settings)
            }
            .pickerStyle(.segmented)
            .padding()
            
            TabView(selection: $selectedView) {
                CalendarTabView(viewModel: viewModel)
                    .tag(ViewType.calendar)
                
                Text("Availability View") // Reemplazar con AvailabilityTabView
                    .tag(ViewType.availability)
                
                Text("Settings View") // Reemplazar con ScheduleSettingsTabView
                    .tag(ViewType.settings)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Schedule Management")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button (action: {
                        viewModel.showAddBreak = true
                    }){
                        Label("Add Break", systemImage:"cup.and.saucer")
                    }
                    Button (action: { viewModel.showAddOverride = true}) {
                        Label("block Day", systemImage: "xmark.circle")
                    }
                }
                label: { Image(systemName:"plus.circle.fill")
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

        

#Preview {
    ScheduleCalendarView()
}
