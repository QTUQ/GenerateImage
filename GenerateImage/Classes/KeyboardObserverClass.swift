//
//  KeyboardObserver.swift
//  GEELY
//
//  Created by Tuqa on 12/15/22.
//

import Foundation
import UIKit

    // make a static KeyboardObserver class with reuseable, utility function to use it in any controller
class KeyboardObserver {
    var targetView: UIView!
    static let KeyboardObserverInstance = KeyboardObserver()
    // scroll the view to ensure that the text field or other input element remains visible when the keyboard is present
    func scrollWithKeyboard(view: UIView) { //adding two observers to the default NotificationCente
        targetView = view
        NotificationCenter.default.addObserver(self, selector: #selector((keyboardWillShow)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector((keyboardWillHide)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // when the keyboard is about to be displayed on the screen (This causes the view to move up and make room for the keyboard to be displayed)
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if targetView.frame.origin.y == 0 {
                targetView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    // when the keyboard is about to be dismissed (This causes the view to move down and fill the space left by the keyboard)
    @objc func keyboardWillHide(notification: NSNotification) {
        if targetView.frame.origin.y != 0 {
            targetView.frame.origin.y = 0
        }
    }
}

