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

precedencegroup AlphaPrecedence {
  associativity: left
  higherThan: RangeFormationPrecedence
  lowerThan: AdditionPrecedence
}

infix operator ~ : AlphaPrecedence

func ~ (color: DynamicColor, alpha: Int) -> DynamicColor {
  return color ~ CGFloat(alpha)
}
func ~ (color: DynamicColor, alpha: Float) -> DynamicColor {
  return color ~ CGFloat(alpha)
}
func ~ (color: DynamicColor, alpha: CGFloat) -> DynamicColor {
  return color.withAlphaComponent(alpha)
}

postfix operator %

postfix func % (percent: Int) -> CGFloat {
  return CGFloat(percent)%
}
postfix func % (percent: Float) -> CGFloat {
  return CGFloat(percent)%
}
postfix func % (percent: CGFloat) -> CGFloat {
  return percent / 100
}

extension UIColor {
  class var charcoal: UIColor { return 0x333333.color }
  class var platinumBorder: UIColor { return 0xDEDEDE.color }
  class var redGraphite: UIColor { return 0xDD4C4F.color }
  class var silver: UIColor { return 0xB3B3B3.color }
  class var snow: UIColor { return 0xFBFBFB.color }
}
