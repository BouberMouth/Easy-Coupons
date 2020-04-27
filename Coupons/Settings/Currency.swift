//
//  Currency.swift
//  Coupons
//
//  Created by Antoine on 22/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable, CustomStringConvertible {
    
    case eur
    case usd
    case cny
    
    var id: Currency {
        self
    }
    
    var description: String {
        switch self {
        case .eur:
            return "€"
        case .usd:
            return "$"
        case .cny:
            return "元"
        }
    }
}
