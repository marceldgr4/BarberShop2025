//
//  SelectBranhView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct SelectBranchView: View {
    @ObservedObject var viewModel: BookingViewModel
    @State private var searchTxt = ""
    
    var filteredBranches: [Branch]{
        if searchTxt.isEmpty{
            return viewModel.branches
        }
        return viewModel.branches.filter{
            $0.name.localizedCaseInsensitiveContains(searchTxt) ||
            $0.address.localizedCaseInsensitiveContains(searchTxt)
        }
    }
    
    var body: some View {
        VStack(spacing:0){
            HStack(spacing: 12){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search branches...", text: $searchTxt)
                    .textInputAutocapitalization(.never)
                
                if !searchTxt.isEmpty{
                    Button(action: {searchTxt = ""}){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
            
            if filteredBranches.isEmpty{
                VStack(spacing: 20){
                    Image(systemName: "building.2")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No branches available")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Please try again ñater")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                ScrollView{
                    LazyVStack(spacing: 15){
                        ForEach(filteredBranches) { branch in
                            BranchSelectionCard(
                                viewModel: viewModel,
                                branch: branch,
                                isSelected: viewModel.selectedBranch?.id == branch.id ) {
                                withAnimation(.spring(response: 0.3)){
                                    viewModel.selectedBranch = branch
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
    SelectBranchView(viewModel: BookingViewModel())
}

