//
//  VersionCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 7/4/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

final class VersionCell: UITableViewCell {

  fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  override var accessoryView: UIView? {
    didSet {
      if self.accessoryView === self.activityIndicatorView {
        self.activityIndicatorView.startAnimating()
      } else {
        self.activityIndicatorView.stopAnimating()
      }
    }
  }

  var isLoading: Bool {
    get { return self.activityIndicatorView.isAnimating }
    set { self.accessoryView = newValue ? self.activityIndicatorView : nil }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
