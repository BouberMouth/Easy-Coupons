//
//  UserNotificationsService.swift
//  Coupons
//
//  Created by Antoine on 21/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationsService {
    
    static var shared = UserNotificationsService()
    
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) {_,_ in }
    }
    
    func setReminderFor(coupon: Coupon, closure: @escaping (_ granted: Bool, _ authorizationError: Error?, _ requestError: Error?) -> ()) {
        
        var authorized: Bool = true
        var authorizationError: Error?
        var requestError: Error?
        
        if let expirationDate = coupon.expirationDate {

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                authorized = granted
                authorizationError = error
            }

            // 1 day notification
            let content = UNMutableNotificationContent()
            content.title = String.localize(forKey: "NOTIFICATIONS.1D_REMINDER.TITLE")
            content.body = String.localize(forKey: "NOTIFICATIONS.1D_REMINDER.BODY")
                                .replacingOccurrences(of: "%offer%", with: coupon.offerDescription)
                                .replacingOccurrences(of: "%brand%", with: coupon.brand.uppercased())
            content.sound = .default

            let notificationDate = expirationDate.addingTimeInterval(-86400)
            var components = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
            
            if let preferredTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.notificationTimePreferenceKey) as? Date {
                let comp = Calendar.current.dateComponents([.hour, .minute], from: preferredTime)
                components.hour = comp.hour ?? 20
                components.minute = comp.minute ?? 15
            } else {
                components.hour = 20
                components.minute = 15
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: "COUPON\(coupon.id)-1D", content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    requestError = error
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm"
            let date = Calendar.current.date(from: components)
            let dform = dateFormatter.string(from: date!)
            
            print("NOTIFICATION WILL BE SENT ON \(dform)")
            
            // 1 week notification
            let content2 = UNMutableNotificationContent()
            content2.title = String.localize(forKey: "NOTIFICATIONS.1W_REMINDER.TITLE")
            content2.body = String.localize(forKey: "NOTIFICATIONS.1W_REMINDER.BODY")
                                .replacingOccurrences(of: "%offer%", with: coupon.offerDescription)
                                .replacingOccurrences(of: "%brand%", with: coupon.brand.uppercased())
            content2.sound = .default

            let notificationDate2 = expirationDate.addingTimeInterval(-86400*7)
            var components2 = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate2)
            
            if let preferredTime2 = UserDefaults.standard.object(forKey: UserDefaultsKeys.notificationTimePreferenceKey) as? Date {
                let comp = Calendar.current.dateComponents([.hour, .minute], from: preferredTime2)
                components2.hour = comp.hour ?? 20
                components2.minute = comp.minute ?? 15
            } else {
                components2.hour = 20
                components2.minute = 15
            }
            
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: components2, repeats: false)

            let request2 = UNNotificationRequest(identifier: "COUPON\(coupon.id)-1W", content: content2, trigger: trigger2)

            center.add(request2) { (error) in
                if let error = error {
                    requestError = error
                }
            }
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "EEEE, MMM d, yyyy HH:mm"
            let date2 = Calendar.current.date(from: components2)
            let dform2 = dateFormatter.string(from: date2!)
            
            print("NOTIFICATION WILL BE SENT ON \(dform2)")
            
        }
        
        closure(authorized, authorizationError, requestError)
    }
    
    
    
    func removeNotificationsFor(coupon: Coupon) {
        center.removePendingNotificationRequests(withIdentifiers: ["COUPON\(coupon.id)-1D", "COUPON\(coupon.id)-1W"])
    }
    
    func rescheduleNotificationsWithNewTime(date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour else { return }
        guard let minute = components.minute else { return }
        
        center.getPendingNotificationRequests { (requests) in
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    var dateComponents = trigger.dateComponents
                    dateComponents.hour = hour
                    dateComponents.minute = minute
                    let newTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: newTrigger)
                    
                    self.center.add(newRequest) { (error) in
                        if let error = error {
                            print(" ERROR: \(error) ")
                        }
                    }
                }
            }
        }
    }
    
    func printNotifId() {
        center.getPendingNotificationRequests { (notif) in
            print(notif.count)
            for n in notif {
                print(n.identifier)
            }
        }
    }
}
