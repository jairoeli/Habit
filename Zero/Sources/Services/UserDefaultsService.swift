//
//  UserDefaultsService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

extension UserDefaultsKey {
  static var habits: Key<[[String: Any]]> { return "habits" }
}

protocol UserDefaultsServiceType {
  func value<T>(forKey key: UserDefaultsKey<T>) -> T?
  func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: BaseService, UserDefaultsServiceType {

  private var defaults: UserDefaults {
    return UserDefaults.standard
  }

  func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
    return self.defaults.value(forKey: key.key) as? T
  }

  func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
    self.defaults.set(value, forKey: key.key)
    self.defaults.synchronize()
  }

}
