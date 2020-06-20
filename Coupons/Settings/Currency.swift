//
//  Currency.swift
//  Coupons
//
//  Created by Antoine on 22/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable, CustomStringConvertible {
    case aud
    case bgn
    case brl
    case cad
    case chf
    case cny
    case czk
    case dkk
    case eur
    case gbp
    case hkd
    case hrk
    case huf
    case idr
    case ils
    case inr
    case isk
    case jpy
    case krw
    case mxn
    case myr
    case nok
    case nzd
    case php
    case pln
    case ron
    case rub
    case sek
    case sgd
    case thb
    case _try
    case usd
    case zar
    
    var id: Currency {
        self
    }
    
    var sign: String {
        switch self {
        case .aud, .cad, .mxn, .nzd, .sgd, .usd:
            return "$"
        case .bgn:
            return "лв."
        case .brl:
            return "R$"
        case .chf:
            return "CHF"
        case .cny, .jpy:
            return "¥"
        case .czk:
            return "kč"
        case .dkk:
            return "kr."
        case .eur:
            return "€"
        case .gbp:
            return "£"
        case .hkd:
            return "HK$"
        case .hrk:
            return "kn"
        case .huf:
            return "Ft"
        case .idr:
            return "Rp"
        case .ils:
            return "₪"
        case .inr:
            return "₹"
        case .isk:
            return "ISK"
        case .krw:
            return "￦"
        case .myr:
            return "RM"
        case .nok, .sek:
            return "kr"
        case .php:
            return "₱"
        case .pln:
            return "zł"
        case .ron:
            return "RON"
        case .rub:
            return "₽"
        case .thb:
            return "฿"
        case ._try:
            return "₺"
        case .zar:
            return "R"
        }
    }
    
    var description: String {
        switch self {
        case .aud:
            return "AUD ($)"
        case .bgn:
            return "BGN (лв.)"
        case .brl:
            return "BRL (R$)"
        case .cad:
            return "CAD ($)"
        case .chf:
            return "CHF (CHF)"
        case .cny:
            return "CNY (¥)"
        case .czk:
            return "CZK (kč)"
        case .dkk:
            return "DKK (kr.)"
        case .eur:
            return "EUR (€)"
        case .gbp:
            return "GBP (£)"
        case .hkd:
            return "HKD (HK$)"
        case .hrk:
            return "HRK (kn)"
        case .huf:
            return "HUF (Ft)"
        case .idr:
            return "IDR (Rp)"
        case .ils:
            return "ILS (₪)"
        case .inr:
            return "INR (₹)"
        case .isk:
            return "ISK (ISK)"
        case .jpy:
            return "JPY (¥)"
        case .krw:
            return "KRW (￦)"
        case .mxn:
            return "MXN ($)"
        case .myr:
            return "MYR (RM)"
        case .nok:
            return "NOK (kr)"
        case .nzd:
            return "NZD ($)"
        case .php:
            return "PHP (₱)"
        case .pln:
            return "PLN (zł)"
        case .ron:
            return "RON (RON)"
        case .rub:
            return "RUB (₽)"
        case .sek:
            return "SEK (kr)"
        case .sgd:
            return "SGD ($)"
        case .thb:
            return "THB (฿)"
        case ._try:
            return "TRY (₺)"
        case .usd:
            return "USD ($)"
        case .zar:
            return "ZAR (R)"
        }
    }
    
    func formattedPriceFor(_ price: Double) -> String {
        let (whole, cents) = price.priceComponants()
        switch self {
        case .eur:
            return "\(whole)\(sign)\(cents)"
        default:
            return sign + "\(whole).\(cents)"
        }
    }
    
    func formattedPriceFor(_ price: Int) -> String {
        switch self {
        case .eur:
            return "\(price)" + sign
        default:
            return sign + "\(price)"
        }
    }
}
