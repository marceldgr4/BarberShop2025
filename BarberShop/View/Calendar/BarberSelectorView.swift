import SwiftUI

struct BarberSelectorView: View {
    let onSelect: (BarberWithRating) -> Void
    @State private var barbers: [BarberWithRating] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Select a Barber")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Choose a barber to manage their schedule")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            if isLoading {
                ProgressView()
            } else if !barbers.isEmpty {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(barbers) { barber in
                            Button(action: {
                                onSelect(barber)
                            }) {
                                HStack {
                                    AsyncImage(url: URL(string: barber.photoUrl ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Circle()
                                            .fill(Color.brandOrange.opacity(0.3))
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    
                                    Text(barber.name)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .task {
            await loadBarbers()
        }
    }
    private func loadBarbers() async {
            isLoading = true
            do {
                let service = BarberService()
                barbers = try await service.fetchBarbers()
            } catch {
                print("Error loading barbers: \(error)")
            }
            isLoading = false
        }
    }
