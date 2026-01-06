//
//  HomeMapSectionView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI
import MapKit
import Combine
struct HomeMapSectionView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                Image(systemName: "map.fill")
                    .foregroundColor(.brandOrange)
                    Text("Our Location")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            if !viewModel.branches.isEmpty{
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.branches){
                    Branch in MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Branch.latitude, longitude: Branch.longitude)){
                        BranchMapMarker(branch: Branch){
                            viewModel.selectBranch(Branch)
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(15)
                .background(Color.black.opacity(0.4))
                .shadow(color: .black.opacity(0.1), radius: 5)
                .padding(.horizontal)
                
                if let selectedBranch = viewModel.selectedBranch{
                    NavigationLink(destination: BranchDetailView(branch: selectedBranch)){
                        BranchRowItem(branch: selectedBranch)
                            .padding(.horizontal)
                    }
                }
            } else{
                PlaceholderMapView(isLoading: viewModel.isLoading, onRefresh:{
                    Task{ await viewModel.loadHomeData()}
                })
            }
        }
    }
}

#Preview {
    HomeMapSectionView(viewModel: HomeViewModel())
}
