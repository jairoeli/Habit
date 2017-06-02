//
//  AppDelegate.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import SnapKit
import ManualLayout
import RxOptional
import RxReusable
import SwiftyImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .snow
    window.makeKeyAndVisible()

    let serviceProvider = ServiceProvider()
    let reactor = TaskListViewReactor(provider: serviceProvider)
    let viewController = TaskListViewController(reactor: reactor)
    let navigationController = UINavigationController(rootViewController: viewController)
    window.rootViewController = navigationController

    self.window = window
    return true
  }

}
