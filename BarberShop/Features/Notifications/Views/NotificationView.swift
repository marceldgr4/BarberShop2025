//
//  NotificationView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import SwiftUI

struct NotificationView: View {
    @StateObject private var service = NotificationService.shared
    @State private var selectedFilter: Notification.NotificationType?
    
    var filteredNotifications: [Notification]{
        if let filter = selectedFilter{
            return service.notifications.filter{ $0.type == filter}
        }
        return service.notifications
    }
    
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                if service.notifications.isEmpty{
                    emptyState
                }else{
                    NotificationsList
                }
            }
            
            .navigationTitle("Notification")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu {
                        Button(action: {service.markAllsRead()    }) {
                            Label("Mark all Read", systemImage:"checkmark.circle")
                        }
                        
                        Button(role: .destructive, action:{service.clearAll()}) {
                            Label("Clear all", systemImage: "trash")
                        }
                    }label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.brandOrange)
                    }
                }
            }
        }
    }
    
    private var emptyState: some View{
        VStack(spacing:20){
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("No Notificaions")
                .font(.title2)
                .fontWeight(.bold)
            Text("You´re all caught Up!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var NotificationsList:  some View{
        List{
            Section{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing:12){
                        FilterChip(title: "All", isSelected: selectedFilter == nil, action: {selectedFilter = nil })
                        ForEach([
                            Notification.NotificationType.promotion,
                            .appointment,.cancellation,.reminder
                        ], id:\.self)
                        {type in FilterChip(
                            title: type.rawValue.capitalized,
                            isSelected: selectedFilter == type,
                            action: { selectedFilter = type}
                        )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            Section{
                ForEach(filteredNotifications){ notificacion in NotificationRow(notificacion: notificacion){
                    service.markAsRead(notificacion.id)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true){
                    Button(role: .destructive){
                        service.deleteNotificacion(notificacion.id)
                    } label: {
                        Label("Delete",systemImage: "trash")
                    }
                }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
    

#Preview {
    NotificationView()
}
