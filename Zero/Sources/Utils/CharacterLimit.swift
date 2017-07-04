//
//  CharacterLimit.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

extension NSRange {
  func range(for str: String) -> Range<String.Index>? {
    guard location != NSNotFound else { return nil }

    guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
    guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
    guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
    guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }

    return fromIndex ..< toIndex
  }
}

// MARK: - Character limit
extension HabitListViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = range.range(for: currentText) else { return false }

    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

    return updatedText.characters.count <= 20
  }
}
