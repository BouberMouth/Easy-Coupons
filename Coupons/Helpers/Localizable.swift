//
//  Localizable.swift
//  I Learn Chengyus
//
//  Created by Antoine on 31/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import Foundation

private class Localizator {
    
    static let shared = Localizator()
    
    lazy var localizedDictionnary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(_ key: String) -> String {
        print(key)
        guard let localizedString = localizedDictionnary.value(forKeyPath: "\(key).value") as? String else {
            assertionFailure("Missing translation for key: \(key)")
            return ""
        }
        return localizedString
    }
}

extension String {
    static func localize(forKey key: String) -> String {
        return Localizator.shared.localize(key)
    }
}
