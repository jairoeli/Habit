//
//  YearProgress.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 10/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

class CalculateProgress: NSObject {

  class func result() -> String {
    let calendar = NSCalendar.current
    let currentDate = Date()
    guard let passedDays = calendar.ordinality(of: .day, in: .year, for: currentDate) else { return "" }
    let year = calendar.component(.year, from: currentDate)
    var daysInYear = 0

    if year % 4 == 0 && year % 400 != 0 || year % 400 == 0 {
      daysInYear = 366
    } else {
      daysInYear = 365
    }

    let progress = Float(passedDays) / Float(daysInYear) * 100
    var string = ""

    for i in 0 ..< 20 {
      if i < Int(progress / 5) {
        string += "▓"
      } else {
        string += "░"
      }
    }

    return string
  }

  class func percent() -> String {
    let calendar = NSCalendar.current
    let currentDate = Date()
    guard let passedDays = calendar.ordinality(of: .day, in: .year, for: currentDate) else { return "" }
    let year = calendar.component(.year, from: currentDate)
    var daysInYear = 0

    if year % 4 == 0 && year % 400 != 0 || year % 400 == 0 {
      daysInYear = 366
    } else {
      daysInYear = 365
    }

    let progress = Float(passedDays) / Float(daysInYear) * 100
    let string = "\(Int(progress))%"
    return string
  }

}
