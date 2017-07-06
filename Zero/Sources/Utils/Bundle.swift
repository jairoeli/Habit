//
//  Bundle.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 7/3/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

extension Bundle {
  var version: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }

  var build: String? {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
  }
}
