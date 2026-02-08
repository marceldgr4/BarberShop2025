//
//  NotificationService.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 6/01/26.
//

import Foundation
import Combine
import UserNotifications
import UIKit

final class NotificationService: ObservableObject{
    static let shared = NotificationService()
    
    @Published var notifications : [Notification] = [ ]
    @Published var unreadCount: Int = 0
    
    private let cacheKey = "Notifications"
     let notificationCenter = UNUserNotificationCenter.current()
    
    private init(){
        loadNotification()
        requestPermission()
    }
    
    func requestPermission(){
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]){
            granted, error in
            if granted{
                print("Permiso de noticaciones otorgados")
            }
            else{
                print("Permsino de notificaciones denegado")
            }
        }
    }
    
    private func loadNotification(){
        if let cached = CacheManager.shared.get([Notification].self, forKey: cacheKey){
            notifications = cached.sorted{$0.timestamp > $1.timestamp}
            updateUnreadCount()
        }
    }
    
    private func saveNotification(){
        CacheManager.shared.set(notifications,forKey:cacheKey,policy: .persistent)
    }
    
    func addNotification(
        type: Notification.NotificationType,
        title: String,
        message: String,
        actionURL: String? = nil,
        metadata: [String: String]? = nil
        
    ){
        let notificacion = Notification(id: UUID(),
                                        type: type,
                                        title: title,
                                        message: message,
                                        timestamp: Date(),
                                        isRead: false,
                                        actionURL: actionURL,
                                        metaData: metadata
        )
        notifications.insert(notificacion, at: 0)
        saveNotification()
        
        scheduleLocalNotification(notificacion)
    }
    
    func markAsRead(_ id:UUID){
        if let index = notifications.firstIndex(where: {$0.id == id}){
            notifications[index].isRead = true
            saveNotification()
        }
    }
    func markAllsRead(){
        notifications = notifications.map{ var n = $0; n.isRead = true; return n}
        saveNotification()
    }
    func deleteNotificacion(_ id: UUID){
        notifications.removeAll(){$0.id == id }
        saveNotification()
    }
    func clearAll(){
        notifications.removeAll()
        saveNotification()
    }
    
    private func updateUnreadCount(){
        unreadCount = notifications.filter{!$0.isRead}.count
        UIApplication.shared.applicationIconBadgeNumber = unreadCount
    }
    
    private func scheduleLocalNotification(_ notification: Notification){
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: notification.id.uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}
