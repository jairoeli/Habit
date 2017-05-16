//
//  MessageInputBar.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/14/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class MessageInputBar: UIView {

  // MARK: UI
  fileprivate let textView = UIView() <== {
    $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
    $0.layer.borderWidth = 1 / UIScreen.main.scale
  }

  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.textView)

    self.textView.snp.makeConstraints { make in make.edges.equalTo(0) }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 65)
  }

}
