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
    
    func setReminderFor(coupon: Coupon, closure: @escaping (_ granted: Bool, _ authorizationError: Error?, _ requestError: Error?) -> ()) {
        
        var authorized: Bool = true
        var authorizationError: Error?
        var requestError: Error?
        
        if let expirationDate = coupon.expirationDate {

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                authorized = granted
                authorizationError = error
            }

            let content = UNMutableNotificationContent()
            content.title = "Your coupon  expires tomorrow !"
            content.body = "You still have one day to use your \(coupon.offerDescription) coupon at \(coupon.brand.uppercased()) !"
            content.sound = .default

            let notificationDate = expirationDate.addingTimeInterval(-86400)
            var components = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
            components.hour = 20
            components.minute = 15

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: "COUPON\(coupon.id)", content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    requestError = error
                }
            }
        }
        
        closure(authorized, authorizationError, requestError)
    }
    
    
    
    func removeNotificationsFor(coupon: Coupon) {
        center.removePendingNotificationRequests(withIdentifiers: ["COUPON\(coupon.id)"])
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
