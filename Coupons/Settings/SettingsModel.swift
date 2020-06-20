//
//  SettingsModel.swift
//  Coupons
//
//  Created by Antoine on 22/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import SwiftUI

class SettingsModel: ObservableObject {
    
    let app = UserDefaults.standard
    
    @Published var selectedLanguage: Language {
        didSet {
            app.set(selectedLanguage.rawValue, forKey: UserDefaultsKeys.languagePreferenceKey)
        }
    }
    
    @Published var selectedCurrency: Currency {
        didSet {
            app.set(selectedCurrency.rawValue, forKey: UserDefaultsKeys.currencyPreferenceKey)
        }
    }
    
    @Published var selectedNotificationTime: Date {
        didSet {
            app.set(selectedNotificationTime, forKey: UserDefaultsKeys.notificationTimePreferenceKey)
            UserNotificationsService.shared.rescheduleNotificationsWithNewTime(date: selectedNotificationTime)
        }
    }
    
    @Published var selectedTintColor: TintColor {
        didSet {
            app.set(selectedTintColor.rawValue, forKey: UserDefaultsKeys.tintPreferenceKey)
        }
    }
    
    var description: String {
        return "LANGUAGE: \(selectedLanguage)\nCURRENCY: \(selectedCurrency)\nNOTIFICATIONS: \(selectedNotificationTime)\n"
    }
    
    init() {
        if let languageRV = app.string(forKey: UserDefaultsKeys.languagePreferenceKey),
            let language = Language.init(rawValue: languageRV) {
                self.selectedLanguage = language
        } else {
            self.selectedLanguage = .english
        }
        
        if let currencyRV = app.string(forKey: UserDefaultsKeys.currencyPreferenceKey),
            let currency = Currency.init(rawValue: currencyRV) {
                self.selectedCurrency = currency
        } else {
            self.selectedCurrency = .eur
        }
        
        if let tintColorRV = app.string(forKey: UserDefaultsKeys.tintPreferenceKey),
            let tintColor = TintColor(rawValue: tintColorRV) {
            self.selectedTintColor = tintColor
        } else {
            self.selectedTintColor = .blue
        }

        
        if let date = app.object(forKey: UserDefaultsKeys.notificationTimePreferenceKey) as? Date {
            self.selectedNotificationTime = date
        } else {
            let date = Date()
            var components = Calendar.current.dateComponents([.hour, .minute], from: date)
            components.hour = 20
            components.minute = 15
            let notifDate = Calendar.current.date(from: components)
            self.selectedNotificationTime = notifDate ?? date
        }
    }
}
