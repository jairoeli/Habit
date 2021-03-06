//
//  AppStoreService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 7/3/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxSwift

protocol AppStoreServiceType {
  func latestVersion() -> Single<String?>
}

final class AppStoreService: BaseService, AppStoreServiceType {
  fileprivate let networking = Networking<AppStoreAPI>()

  func latestVersion() -> Single<String?> {
    guard let bundleID = Bundle.main.bundleIdentifier else { return .just(nil) }
    return self.networking.request(.lookup(bundleID: bundleID))
      .mapJSON()
      .flatMap { json -> Single<String?> in
        let version = (json as? [String: Any])
          .flatMap { $0["results"] as? [[String: Any]] }
          .flatMap { $0.first }
          .flatMap { $0["version"] as? String }
        return .just(version)
    }
  }
}
