//
//  DateExtension.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/1/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

extension Date {
  func currentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM d"
    return dateFormatter.string(from: self).uppercased()
  }
}

class TimeOfTheDay: NSObject {

  class func getGreetingFromTheCurrentOfTheDay () -> (String) {
    var greetingMessage = "Good Morning!"

    switch TimeOfTheDay.getTimeOfTheDay() {
      case 12...15: greetingMessage = "Good Afternoon!"
      case 16...23: greetingMessage = "Good Evening!"
      default: break
    }

    return greetingMessage
  }

  class func getTimeOfTheDay() -> (Int) {
    return Calendar.current.component(.hour, from: Date())
  }
}
