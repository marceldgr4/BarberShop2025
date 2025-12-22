//
//  PrivacySettingsView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct PrivacySettingsView: View {
    var body: some View {
        Form{
            Section("Privacy"){
                NavigationLink("Terms of Service", destination: Text("terms of services"))
                NavigationLink("Privacy Policy", destination: Text("Privacy Policy"))
            }
        }
        .navigationTitle("Privacy")
    }
}

#Preview {
    PrivacySettingsView()
}
