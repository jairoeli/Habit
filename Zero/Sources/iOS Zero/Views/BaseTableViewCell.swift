//
//  BaseTableViewCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/16/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import RxSwift

class BaseTableViewCell: UITableViewCell {

  // MARK: - Property

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: - Initializing

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initialize()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(style: .default, reuseIdentifier: nil)
  }

  func initialize() {
    // Override point
  }

}
