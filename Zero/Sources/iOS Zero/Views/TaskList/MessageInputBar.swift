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
    $0.backgroundColor = .snow
  }

  fileprivate let separatorView = UIView() <== {
    $0.backgroundColor = UIColor(white: 0.85, alpha: 1)
  }

  fileprivate lazy var settingsButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
    $0.tintColor = .charcoal ~ 75%
  }

  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.textView)
    self.addSubview(self.separatorView)
    self.addSubview(self.settingsButton)

    self.textView.snp.makeConstraints { make in make.edges.equalTo(0) }

    self.separatorView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }

    self.settingsButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.textView.snp.bottom).offset(-2)
      make.left.equalToSuperview()
      make.width.equalTo(44)
      make.height.equalTo(44)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 85)
  }

}

extension Reactive where Base: MessageInputBar {

  var settingsButtonTap: ControlEvent<Void> {
    let source = base.settingsButton.rx.tap
    return ControlEvent(events: source)
  }

  var tintColor: UIBindingObserver<Base, UIColor> {
    return UIBindingObserver(UIElement: self.base) { navigationBar, tintColor in
      navigationBar.tintColor = tintColor
    }
  }

}
