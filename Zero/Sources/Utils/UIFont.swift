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

  static func regular(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
  }
}

// swiftlint:disable valid_docs
extension UIFont {

  /// black, 28pt font, 34pt leading, 13pt tracking
  static func title1() -> UIFont {
    return .dynamicSize(style: .title1, weight: .black)
  }

  /// medium, 20pt font, 24pt leading, 19pt tracking
  static func title3() -> UIFont {
    return .dynamicSize(style: .title3, weight: .medium)
  }

  /// medium, 17pt font, 22pt leading, -24pt tracking
  static func body() -> UIFont {
    return .dynamicSize(style: .body, weight: .medium)
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
      case .regular: return UIFontWeightRegular
      case .medium: return UIFontWeightMedium
      case .semibold: return UIFontWeightSemibold
      case .bold: return UIFontWeightBold
      case .heavy: return UIFontWeightHeavy
      case .black: return UIFontWeightBlack
      }
    }
  }

  static func dynamicSize(style: UIFontTextStyle, weight: FontWeight) -> UIFont {
    let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
    return UIFont.systemFont(ofSize: pointSize, weight: weight.CGFloatValue)
  }

}
