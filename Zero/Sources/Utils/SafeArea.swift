//
//  SafeArea.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 10/5/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import SnapKit

extension UIViewController {
  var safeAreaTop: ConstraintItem {
    guard #available(iOS 11, *) else {
      return self.topLayoutGuide.snp.bottom
    }
    return self.view.safeAreaLayoutGuide.snp.topMargin
  }

  var safeAreaBottom: ConstraintItem {
    guard #available(iOS 11, *) else {
      return self.bottomLayoutGuide.snp.top
    }
    return self.view.safeAreaLayoutGuide.snp.bottomMargin
  }
}
