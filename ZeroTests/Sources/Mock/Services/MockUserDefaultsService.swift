//
//  MockUserDefaultsService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

@testable import Zero

final class MockUserDefaultsService: UserDefaultsServiceType {
  var store = [String: Any]()

  func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
    return self.store[key.key] as? T
  }

  func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
    if let value = value {
      self.store[key.key] = value
    } else {
      self.store.removeValue(forKey: key.key)
    }
  }
}
