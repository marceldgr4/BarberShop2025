import SwiftUI

// MARK: - Empty Schedule View
struct EmptyScheduleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Schedule Available")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("This barber doesn't have a schedule configured for this day")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Blocked Day View
struct BlockedDayView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red.opacity(0.5))
            
            Text("Day Blocked")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("This day is blocked due to vacation, holiday, or special circumstances")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
