//
//  UITableView+ScrollToBottom.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 9/29/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

import UIKit

extension UITableView {

  func isReachedBottom(withOffset offset: CGFloat = 0) -> Bool {
    guard self.contentSize.height > self.height, self.height > 0 else { return true }
    let contentOffsetBottom = self.contentOffset.y + self.height
    return contentOffsetBottom - offset >= self.contentSize.height
  }

  func scrollToBottom(animated: Bool) {
    let scrollHeight = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
    guard scrollHeight > self.height, self.height > 0 else { return }
    let targetOffset = CGPoint(x: 0, y: self.contentSize.height + self.contentInset.bottom - self.height)
    self.setContentOffset(targetOffset, animated: animated)
  }

}
