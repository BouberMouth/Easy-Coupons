//
//  DateLabel.swift
//  Coupons
//
//  Created by Antoine on 27/05/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

class DateLabel {
    
    func getLabel(date: Date) -> String {
        let daysToDate = Date.daysBetween(start: Date(), end: date)
        
        if daysToDate < 0 {
            return String.localize(forKey: "COUPON.EXP_DESCRIPTION.EXPIRED")
        }
        
        switch daysToDate {
        case 0:
            return String.localize(forKey: "COUPON.EXP_DESCRIPTION.TODAY")
        case 1:
            return String.localize(forKey: "COUPON.EXP_DESCRIPTION.TOMORROW")
        default:
            return String.localize(forKey: "COUPON.EXP_DESCRIPTION.IN_X_DAYS")
                    .replacingOccurrences(of: "%n%", with: String(daysToDate))
        }
    }
    
}


extension Date {
    static func daysBetween(start: Date, end: Date) -> Int {
        let s = Calendar.current.startOfDay(for: start)
        let e = Calendar.current.startOfDay(for: end)
        return Calendar.current.dateComponents([.day], from: s, to: e).day!
    }
}
