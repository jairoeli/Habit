//
//  BaseCollectionViewCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/15/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }
}
