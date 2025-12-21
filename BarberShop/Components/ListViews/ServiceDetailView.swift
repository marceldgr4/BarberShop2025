//
//  ServiceDetailView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: Service
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
                AsyncImage(url: URL(string: service.imageUrl ?? "")){
                    image in image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }placeholder: {
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                }
                .frame(height: 250)
                .clipped()
                VStack(alignment: .leading, spacing: 15){
                    Text(service.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let description = service.description{
                        Text(description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    Divider()
                    HStack{
                        VStack(alignment: .leading){
                            Text("Price")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.0f", service.price))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color.brandOrange)
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(service.durationMinutes) min")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    Button( action: {
                        
                    }){
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Book Now")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandGradient)
                        .cornerRadius(12)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

