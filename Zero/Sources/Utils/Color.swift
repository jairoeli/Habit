//
//  Color.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
typealias DynamicColor = UIColor

extension Int {
  var color: DynamicColor {
    let red = CGFloat(self as Int >> 16 & 0xff) / 255
    let green = CGFloat(self >> 8 & 0xff) / 255
    let blue  = CGFloat(self & 0xff) / 255
    return DynamicColor(red: red, green: green, blue: blue, alpha: 1)
  }
}

extension UIColor {
  class var slate: UIColor { return 0xD5D5D5.color }
  class var charcoal: UIColor { return 0x333333.color }
}

extension UIFont {
  static func bold(size: CGFloat) -> UIFont {
    return UIFont(name: "AvenirNext-Bold", size: size)!
  }
}
