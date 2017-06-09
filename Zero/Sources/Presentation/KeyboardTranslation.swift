//
//  KeyboardTranslation.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

enum KeyboardTranslationType {

    case none
    case moveUp

    /**
     Calculates the correct frame for the keyboard translation type.

     - parameter keyboardFrame: The UIKeyboardFrameEndUserInfoKey CGRect Value of the Keyboard
     - parameter presentedFrame: The frame of the presented controller that may need to be translated.
     - returns: CGRect representing the new frame of the presented view.
     */
    func getTranslationFrame(keyboardFrame: CGRect, presentedFrame: CGRect) -> CGRect {
        let keyboardTop = UIScreen.main.bounds.height - keyboardFrame.size.height
        let presentedViewBottom = presentedFrame.origin.y + presentedFrame.height
        let offset = presentedViewBottom - keyboardTop
        switch self {
        case .moveUp:
            if offset > 0.0 {
                let frame = CGRect(x: presentedFrame.origin.x, y: presentedFrame.origin.y-offset, width: presentedFrame.size.width, height: presentedFrame.size.height)
                return frame
            }
            return presentedFrame

        case .none:
            return presentedFrame
        }
    }
}

// MARK: Notification + UIKeyboardInfo

extension Notification {

    /// Gets the optional CGRect value of the UIKeyboardFrameEndUserInfoKey from a UIKeyboard notification
    func keyboardEndFrame () -> CGRect? {
        return (self.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }

    /// Gets the optional AnimationDuration value of the UIKeyboardAnimationDurationUserInfoKey from a UIKeyboard notification
    func keyboardAnimationDuration () -> Double? {
        return (self.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}
