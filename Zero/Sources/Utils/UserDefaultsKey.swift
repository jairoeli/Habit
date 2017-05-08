//
//  UserDefaultsKey.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

struct UserDefaultsKey<T> {
  typealias Key<T> = UserDefaultsKey<T>
  let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
  init(unicodeScalarLiteral value: StringLiteralType) {
    self.init(key: value)
  }

  init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(key: value)
  }

  init(stringLiteral value: StringLiteralType) {
    self.init(key: value)
  }
}
