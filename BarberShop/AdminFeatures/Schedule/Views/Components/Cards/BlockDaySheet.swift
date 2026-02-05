import SwiftUI

struct BlockDaySheet: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var selectedReason: ScheduleOverride.OverrideReason = .personal
    @State private var customReason = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Date Selection
                Section {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                } header: {
                    Text("Date to Block")
                } footer: {
                    Text("Select the date when the barber will not be available")
                }
                
                // MARK: - Reason Selection
                Section("Reason") {
                    Picker("Type", selection: $selectedReason) {
                        ForEach([
                            ScheduleOverride.OverrideReason.vacation,
                            .sick,
                            .personal,
                            .training,
                            .custom
                        ], id: \.self) { reason in
                            HStack {
                                Image(systemName: reason.icon)
                                Text(reason.displayName)
                            }
                            .tag(reason)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    // Custom Reason TextField
                    if selectedReason == .custom {
                        TextField("Describe the reason", text: $customReason)
                            .textInputAutocapitalization(.sentences)
                    }
                }
                
                // MARK: - Reason Templates
                if selectedReason == .custom {
                    Section("Quick Templates") {
                        Button("Medical Appointment") {
                            customReason = "Medical Appointment"
                        }
                        Button("Family Emergency") {
                            customReason = "Family Emergency"
                        }
                        Button("Personal Day") {
                            customReason = "Personal Day"
                        }
                    }
                }
                
                // MARK: - Summary
                Section("Summary") {
                    HStack {
                        Label("Date", systemImage: "calendar")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(formatDate(selectedDate))
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Label("Reason", systemImage: selectedReason.icon)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(selectedReason == .custom && !customReason.isEmpty ? customReason : selectedReason.displayName)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Label("Status", systemImage: "xmark.circle.fill")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Day Blocked")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                
                // MARK: - Warning
                Section {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.brandAccent)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Important")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("All appointments for this day will be unavailable. Existing appointments will need to be rescheduled.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Block Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Block") {
                        Task {
                            await blockDay()
                        }
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                    .foregroundColor(isValid ? .red : .gray)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Validation
    private var isValid: Bool {
        if selectedReason == .custom {
            return !customReason.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return true
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func blockDay() async {
        guard isValid else {
            errorMessage = "Please provide a reason for blocking this day"
            showError = true
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        
        let reason = selectedReason == .custom && !customReason.isEmpty ? customReason : nil
        
        await viewModel.blockDay(
            date: dateString,
            reason: selectedReason,
            customReason: reason
        )
        
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    BlockDaySheet(viewModel: ScheduleViewModel())
}
