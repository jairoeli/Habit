//
//  ServiceProvider.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

protocol ServiceProviderType: class {
  var userDefaultsService: UserDefaultsServiceType { get }
  var alertService: AlertServiceType { get }
  var taskService: TaskServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
  lazy var alertService: AlertServiceType = AlertService(provider: self)
  lazy var taskService: TaskServiceType = TaskService(provider: self)
}
