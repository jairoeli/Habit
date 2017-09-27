//
//  AppDelegate.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ManualLayout
import RxOptional
import SnapKit
import UITextView_Placeholder
import RxGesture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.configureAppearance()

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .snow
    window.makeKeyAndVisible()

    let serviceProvider = ServiceProvider()
    let reactor = HabitListViewReactor(provider: serviceProvider)
    let viewController = HabitListViewController(reactor: reactor)
    let navigationController = UINavigationController(rootViewController: viewController)
    window.rootViewController = navigationController

    self.window = window
    return true
  }

  // MARK: - Appearance
  private func configureAppearance() {
    UINavigationBar.appearance().barTintColor = .snow
    UINavigationBar.appearance().tintColor = .midGray
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
  }

}
