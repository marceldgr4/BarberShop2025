//
//  ExploreView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 16/12/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = BranchViewModel()
    @State private var  searchText = ""
    var body: some View {
        NavigationStack{
            List{
                Section("Branches"){
                    ForEach(filteredBranches) { branch in
                        NavigationLink(destination: BranchDetailView( branch: branch)){
                            BranchRowItem(branch: branch)
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText, prompt: "Search Branches")
            .task {
                await viewModel.loadBranches()
            }
        }
    }
    private var filteredBranches: [Branch]{
        if searchText.isEmpty{
            return viewModel.braches
        }
        return viewModel.braches.filter{
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    ExploreView()
}
