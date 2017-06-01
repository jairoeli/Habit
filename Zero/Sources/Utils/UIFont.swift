//
//  UIFont.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/1/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

extension UIFont {
  static func black(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFontWeightBlack)
  }

  static func medium(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
  }
}
