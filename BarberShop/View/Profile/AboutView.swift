//
//  AboutView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
            Section("App Information") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("2025.12.21")
                        .foregroundColor(.gray)
                }
            }
            
            Section {
                Link("Visit Website", destination: URL(string: "https://barbershop.com")!)
                Link("Rate on App Store", destination: URL(string: "https://apps.apple.com")!)
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
