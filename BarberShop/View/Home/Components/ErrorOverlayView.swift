//
//  ErrorOverlayView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct ErrorOverlayView: View {
    let error: String
    let retryAction: ()-> Void
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.brandOrange)
                Text(error)
                    .font(.subheadline)
                Button("Retry", action: retryAction)
                    .font(.caption)
                    .padding(.horizontal,12)
                    .padding(.vertical,12)
                    .background(Color.brandOrange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            .padding()
        }
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    ErrorOverlayView(error: "Error", retryAction: {})
}
