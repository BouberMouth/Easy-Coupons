//
//  Constant.swift
//  Coupons
//
//  Created by Antoine on 08/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let uniqueCouponIdentifierKey = "uniqueCouponIdentifier"
    
    static let languagePreferenceKey = "languagePreference"
    static let currencyPreferenceKey = "currencyPreference"
    static let notificationTimePreferenceHKey = "notificationTimePreferenceH"
    static let notificationTimePreferenceMKey = "notificationTimePreferenceM"
    static let notificationTimePreferenceKey = "notificationTimePreference"
    static let tintPreferenceKey = "tintPreference"
    
    static func setup() {
        let app = UserDefaults.standard
        
        if app.object(forKey: currencyPreferenceKey) == nil {
            app.set(Currency.eur.rawValue, forKey: currencyPreferenceKey)
        }
        if app.object(forKey: tintPreferenceKey) == nil {
            app.set(TintColor.blue.rawValue, forKey: tintPreferenceKey)
        }
    }
}
