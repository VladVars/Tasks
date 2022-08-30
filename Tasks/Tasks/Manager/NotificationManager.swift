//
//  NotificationManager.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    class func requestAutorezation(task: String, date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { succes, error in
            if succes {
                setNotification(task: task, date: date)
                print("Пользователь дал разрешение!")
            } else {
                print("Ничего пользователь не дал")
            }
        }
    }
    
    class func setNotification(task: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title =  "Здарова, ты не забыл!?"
        content.subtitle = "Через 15 минут нужно:"
        content.body = task
        content.sound = .default
        
        let pushDate = Date(timeIntervalSince1970: date.timeIntervalSince1970 - (15 * 60))
        let calendar = Calendar.current
        let dateComponetns = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: pushDate)
        let calendarTriger = UNCalendarNotificationTrigger(dateMatching: dateComponetns, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: calendarTriger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
}
