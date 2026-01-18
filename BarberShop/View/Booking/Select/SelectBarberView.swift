//
//  SelectBarberView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 1/01/26.
//

import SwiftUI

struct SelectBarberView: View {
    @ObservedObject var viewModel: BookingViewModel
    @State private var searchText = ""
    
    var filteredBarbers: [BarberWithRating]{
        if searchText.isEmpty{
            return viewModel.barbers
        }
        return viewModel.barbers.filter{
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    var body: some View {
        VStack{
            if let branch = viewModel.selectedBranch{
                HStack(spacing: 10){
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.brandOrange)
                    
                    VStack(alignment: .leading, spacing: 2){
                        Text(branch.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(branch.address)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
            }
            //search bar
            HStack(spacing:12){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("searh barber...",text: $searchText)
                    .textInputAutocapitalization(.never)
                if !searchText.isEmpty{
                    Button(action:{ searchText = ""}){
                        Image(systemName: "xmark.cicle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
            
            if filteredBarbers.isEmpty{
                VStack(spacing:20){
                    Image(systemName: "person.3")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No barber availabe")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("this branch doesn´t have barbers yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                ScrollView{
                    LazyVStack(spacing:15){
                        ForEach(filteredBarbers) { barber in
                            BarberSelectionCard( barber: barber, isSelected: viewModel.selectedBarber?.id == barber.id)
                            {withAnimation(.spring(response:0.3)){
                                viewModel.selectedBarber = barber
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    SelectBarberView(viewModel: {
        let vm = BookingViewModel()
        vm.selectedBranch = Branch(
            id: UUID(),
            name: "Central Barbershop",
            address: "Calle 72",
            latitude: 10.9878,
            longitude: -74.7889,
            phone: "+57 300 123 4567",
            email: "central@barbershop.com",
            isActive: true,
            imageUrl: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        return vm
    }())
}
