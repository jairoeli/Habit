//
//  MockServiceProvider.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

@testable import Zero

final class MockServiceProvider: ServiceProviderType {
  lazy var appStoreService: AppStoreServiceType = AppStoreService(provider: self)
  
  lazy var userDefaultsService: UserDefaultsServiceType = MockUserDefaultsService()
  lazy var habitService: HabitServiceType = HabitService(provider: self)
}
