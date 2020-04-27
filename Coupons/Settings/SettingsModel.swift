//
//  SettingsModel.swift
//  Coupons
//
//  Created by Antoine on 22/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

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
//            let components = Calendar.current.dateComponents([.hour, .minute], from: selectedNotificationTime)
//            UserDefaults.standard.set(components.hour ?? 20, forKey: UserDefaultsKeys.notificationTimePreferenceHKey)
//            UserDefaults.standard.set(components.minute ?? 15, forKey: UserDefaultsKeys.notificationTimePreferenceMKey)
            app.set(selectedNotificationTime, forKey: UserDefaultsKeys.notificationTimePreferenceKey)
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
        
//        let notificationHour = UserDefaults.standard.integer(forKey: UserDefaultsKeys.notificationTimePreferenceHKey)
//        let notificationMinute = UserDefaults.standard.integer(forKey: UserDefaultsKeys.notificationTimePreferenceMKey)
//        var components = Calendar.current.dateComponents([.minute, .hour], from: Date())
//        var comp = Calendar.current.comp
//        components.hour = (notificationHour != 0) ? notificationHour : 20
//        components.minute = (notificationMinute != 0) ? notificationMinute : 15
//        selectedNotificationTime = Calendar.current.date(from: comp) ?? Date()
        
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
