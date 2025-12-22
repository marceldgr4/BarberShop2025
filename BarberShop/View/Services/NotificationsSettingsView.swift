//
//  NotificationsSettingsView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 21/12/25.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @State private var pushEnable = true
    @State private var emailEnable = true
    var body: some View {
        Form{
            Section("Notifications"){
                Toggle("Push Notifications", isOn: $pushEnable)
                Toggle("Email Notificaions", isOn: $emailEnable)
            }
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    NotificationsSettingsView()
}
