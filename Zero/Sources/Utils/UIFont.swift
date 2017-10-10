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
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
  }

  static func regular(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
  }
  static func bold(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
  }

}

// swiftlint:disable valid_docs
extension UIFont {

  /// bold, 28pt font, 34pt leading, 13pt tracking
  static func title1() -> UIFont {
    return .dynamicSize(style: .title1, weight: .bold)
  }

  /// medium, 22pt font, 28pt leading, 16pt tracking
  static func title2() -> UIFont {
    return .dynamicSize(style: .title2, weight: .medium)
  }

  /// medium, 20pt font, 24pt leading, 19pt tracking
  static func title3() -> UIFont {
    return .dynamicSize(style: .title3, weight: .medium)
  }

  /// medium, 17pt font, 22pt leading, 19pt tracking
  static func body() -> UIFont {
    return .dynamicSize(style: .body, weight: .regular)
  }

  /// medium, 13pt font, 18pt leading, -6pt tracking
  static func footnote() -> UIFont {
    return .dynamicSize(style: .footnote, weight: .semibold)
  }

  enum FontWeight {
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    var CGFloatValue: CGFloat {
      switch self {
      case .regular: return UIFont.Weight.regular.rawValue
      case .medium: return UIFont.Weight.medium.rawValue
      case .semibold: return UIFont.Weight.semibold.rawValue
      case .bold: return UIFont.Weight.bold.rawValue
      case .heavy: return UIFont.Weight.heavy.rawValue
      case .black: return UIFont.Weight.black.rawValue
      }
    }
  }

  static func dynamicSize(style: UIFontTextStyle, weight: FontWeight) -> UIFont {
    let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
    return UIFont.systemFont(ofSize: pointSize, weight: UIFont.Weight(rawValue: weight.CGFloatValue))
  }

}
