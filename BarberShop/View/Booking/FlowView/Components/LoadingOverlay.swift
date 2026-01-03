//
//  LoadingOverlay.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 30/12/25.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
           Color.black.opacity(0.3)
               .ignoresSafeArea()
               .overlay {
                   VStack(spacing: 15) {
                       ProgressView()
                           .scaleEffect(1.5)
                           .tint(.white)
                       
                       Text("Loading...")
                           .foregroundColor(.white)
                           .font(.subheadline)
                   }
                   .padding(30)
                   .background(.ultraThinMaterial)
                   .cornerRadius(15)
               }
       }
}

#Preview {
    LoadingOverlay()
}
