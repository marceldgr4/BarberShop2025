//
//  NotificationServiceExtension.swift
//  BarberShop
//
//  Created by Marcel Diaz Granados Robayo on 7/02/26.
//

import Foundation
import UserNotifications

extension NotificationService{
    func scheduleAppointmentReminder( appointment: AppointmentDetail){
        guard let appointmentDate = appointment.appointmentDate.toDate(),
              let appointmentTime = appointment.appointmentTime.toTime() else{
            print("Error: Invalid date format")
            return
        }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: appointmentDate)
                let timeComponents = calendar.dateComponents([.hour, .minute], from: appointmentTime)
                
        guard let fullAppointmentDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0,
                                                      of: calendar.date(from: dateComponents)!) else {return}
        
        if let reminder1h = calendar.date(byAdding: .hour, value: -1, to: fullAppointmentDate),
                   reminder1h > Date() {
                    scheduleNotification(
                        id: "\(appointment.id.uuidString)-1h",
                        title: "Appointment in 1 Hour",
                        body: "Your appointment with \(appointment.barberName) starts at \(appointment.formattedTime)",
                        date: reminder1h
                    )
                }
                
                print("Reminders scheduled for appointment \(appointment.id)")
            }
            
            /// Cancela los recordatorios de una cita
            func cancelAppointmentReminders(appointmentId: UUID) {
                let identifiers = [
                    "\(appointmentId.uuidString)-1h"
                ]
                notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                print(" Reminders cancelled for appointment \(appointmentId)")
            }
            
            /// Programa una notificación en una fecha específica
            private func scheduleNotification(id: String, title: String, body: String, date: Date) {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            }
        }
