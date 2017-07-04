//
//  Habit.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

struct Habit: ModelType, Identifiable {

  var id: String = UUID().uuidString
  var title: String
  var memo: String?
  var value: Int = 0

  init(title: String, memo: String? = nil) {
    self.title = title
    self.memo = memo
  }

  init?(dictionary: [String: Any]) {
    guard let id = dictionary["id"] as? String,
      let title = dictionary["title"] as? String
      else { return nil }

    self.id = id
    self.title = title
    self.memo = dictionary["memo"] as? String
    self.value = dictionary["value"] as? Int ?? 0
  }

  func asDictionary() -> [String: Any] {
    var dictionary: [String: Any] = [
      "id": self.id,
      "title": self.title,
      "value": self.value
      ]

    if let memo = self.memo {
      dictionary["memo"] = memo
    }

    return dictionary
  }

}
