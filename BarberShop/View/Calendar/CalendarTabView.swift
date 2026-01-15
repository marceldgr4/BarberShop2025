import SwiftUI

// MARK: - Calendar Tab
struct CalendarTabView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Week Navigator
                WeekNavigator(
                    selectedWeek: viewModel.selectedWeek,
                    selectedDate: $viewModel.selectedDate,
                    onPrevious: { $viewModel.moveToPreviousWeek() },
                    onNext: { $viewModel.moveToNextWeek() }
                )
                
                // Time Blocks
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if viewModel.isDateBlocked {
                    BlockedDayView()
                } else if viewModel.timeBlocks.isEmpty {
                    EmptyScheduleView()
                } else {
                    TimeBlocksGrid(blocks: viewModel.timeBlocks)
                }
            }
            .padding()
        }
    }
}
