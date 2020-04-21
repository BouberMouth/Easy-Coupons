//
//  KeyboardResponder.swift
//  Coupons
//
//  Created by Antoine on 14/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit


final class KeyboardResponder: ObservableObject {
    
    private var notificationCenter: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide() {
        currentHeight = 0
    }
    
}
