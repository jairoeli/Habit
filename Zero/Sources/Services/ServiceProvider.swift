//
//  ServiceProvider.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

protocol ServiceProviderType: class {
  var userDefaultsService: UserDefaultsServiceType { get }
  var habitService: HabitServiceType { get }
  var appStoreService: AppStoreServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
  lazy var habitService: HabitServiceType = HabitService(provider: self)
  lazy var appStoreService: AppStoreServiceType = AppStoreService(provider: self)
}
