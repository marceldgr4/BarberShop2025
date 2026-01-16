//
//  AvailabilityTabView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 15/01/26.
//

import SwiftUI

struct AvailabilityTabView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                WeekAvailabilityCard( viewModel: viewModel)
                
                VStack(alignment: .leading, spacing: 12){
                    Text("Daily Breakdown")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.selectedWeek, id: \.self) {date in
                        DayAvailabilityRow(date: date,viewModel: viewModel)
                    }
                }
                if !viewModel.scheduleOverrides.isEmpty{
                    VStack(alignment: .leading, spacing: 12){
                        Text("Blocked Days")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.scheduleOverrides){
                            override in BlockedDayCard(override: override){
                                Task {
                                    await viewModel.unblockDay(override.id)
                                }
                            }
                        }
                    }
                }
                if !viewModel.breakTimes.isEmpty{
                    VStack(alignment: .leading, spacing: 12){
                        Text("Regular breaks")
                            .font(.headline)
                            .padding(.horizontal)
                        ForEach (viewModel.breakTimes){
                            breakTime in BreakTimeCard(breakTime: breakTime){
                                Task {
                                    await viewModel.deleteBreakTime(breakTime.id)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
            
        }
    }
}

#Preview {
    AvailabilityTabView(viewModel: ScheduleViewModel())
}
