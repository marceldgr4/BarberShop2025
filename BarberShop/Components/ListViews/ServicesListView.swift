//
//  ServiceListView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 20/12/25.
//

import SwiftUI
import Combine

struct ServicesListView: View {
    let services : [Service]
    
    var body: some View {
        List(services) { service in
            NavigationLink(destination: ServiceDetailView(service: service)){
                HStack(spacing: 12){
                    AsyncImage(url: URL(string: service.imageUrl ?? ""))  {image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }placeholder: {
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
                            .overlay(
                                Image(systemName: "scissors")
                                    .foregroundColor(.blue)
                            )
                    }
                    .frame(width: 60,height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(service.name)
                            .font(.headline)
                        
                        if let description = service.description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        
                        HStack {
                            Text("$\(String(format: "%.0f",service.price))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.brandOrange)
                            Text(".")
                                .foregroundColor(.gray)
                            Text("\(service.durationMinutes) min")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("All Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

