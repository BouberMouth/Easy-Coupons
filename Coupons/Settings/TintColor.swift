//
//  TintColor.swift
//  Coupons
//
//  Created by Antoine on 08/05/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

enum TintColor: String, CaseIterable, Identifiable, CustomStringConvertible {
    case blue
    case green
    case indigo
    case orange
    case pink
    case red
    case teal
    case yellow
    
    var id: TintColor {
        return self
    }
    
    var description: String {
        return self.rawValue.capitalized
    }
    
    
    var toUIColor: UIColor {
        switch self {
        case .blue:
            return UIColor.systemBlue
        case .green:
            return UIColor.systemGreen
        case .indigo:
            return UIColor.systemIndigo
        case .orange:
            return UIColor.systemOrange
        case .pink:
            return UIColor.systemPink
        case .red:
            return UIColor.systemRed
        case .teal:
            return UIColor.systemTeal
        case .yellow:
            return UIColor.systemYellow

        }
    }
    
    init(fromUIColor: UIColor) {
        switch fromUIColor {
        case UIColor.systemBlue:
            self = .blue
        case UIColor.systemGreen:
            self = .green
        case UIColor.systemIndigo:
            self = .indigo
        case UIColor.systemOrange:
            self = .orange
        case UIColor.systemPink:
            self = .pink
        case UIColor.systemRed:
            self = .red
        case UIColor.systemTeal:
            self = .teal
        case UIColor.systemYellow:
            self = .yellow
        default:
            self = .pink
        }
    }
    
    static var userPreference: UIColor {
        get {
            if let preferenceRV = UserDefaults.standard.string(forKey: UserDefaultsKeys.tintPreferenceKey),
                let preference = TintColor(rawValue: preferenceRV) {
                return preference.toUIColor
            }
            return TintColor.blue.toUIColor
        }
    }
}
