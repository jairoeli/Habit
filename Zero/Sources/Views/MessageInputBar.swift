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

  fileprivate struct Metric {
    static let padding = 15.f
    static let buttonWidth = 58.f
    static let buttonHeight = 35.f
  }

  var isEnabled: Bool = false {
    didSet {
      self.doneButton.isEnabled = isEnabled
    }
  }

  var buttonColor: UIColor? {
    didSet {
      guard let color = buttonColor else { return }
      self.doneButton.backgroundColor = color
    }
  }

  var borderColor: UIColor? {
    didSet {
      self.doneButton.layer.borderColor = borderColor?.cgColor
    }
  }

  var buttonTitleColor: UIColor? {
    didSet {
      self.doneButton.setTitleColor(buttonTitleColor, for: .normal)
    }
  }

  override var tintColor: UIColor? {
    didSet {
      guard let color = tintColor else { return }
      self.reorderButton.tintColor = color
    }
  }

  // MARK: - UI

  fileprivate lazy var textView = UIView() <== {
    $0.backgroundColor = .snow
  }

  fileprivate lazy var separatorView = UIView() <== {
    $0.backgroundColor = .platinumBorder
  }

  fileprivate lazy var settingsButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), for: .normal)
    $0.tintColor = .midGray
  }

  fileprivate lazy var reorderButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "reorder").withRenderingMode(.alwaysTemplate), for: .normal)
    $0.tintColor = .midGray
  }

  fileprivate lazy var doneButton = UIButton(type: .system) <== {
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.midGray, for: .normal)
    $0.backgroundColor = .snow
    $0.titleLabel?.font = .black(size: 16)
    $0.layer <== {
      $0.borderWidth = 1
      $0.borderColor = UIColor.platinumBorder.cgColor
      $0.cornerRadius = 4
    }
  }

  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    let subviews: [UIView] = [textView, separatorView, settingsButton, reorderButton, doneButton]
    self.add(subviews)
    self.setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 85)
  }

  // MARK: - Layout

  func setupLayout() {
    self.textView.snp.makeConstraints { make in make.edges.equalToSuperview() }

    self.separatorView.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }

    self.settingsButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.textView.snp.bottom).offset(-2)
      make.left.equalToSuperview()
      make.width.height.equalTo(44)
    }

    self.reorderButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.textView.snp.bottom).offset(-2)
      make.left.equalTo(self.settingsButton.snp.right).offset(2)
      make.width.height.equalTo(44)
    }

    self.doneButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.textView.snp.bottom).offset(-6)
      make.right.equalTo(-Metric.padding)
      make.width.equalTo(Metric.buttonWidth)
      make.height.equalTo(Metric.buttonHeight)
    }
  }

}

// MARK: - Reactive
extension Reactive where Base: MessageInputBar {

  var settingsButtonTap: ControlEvent<Void> {
    let source = base.settingsButton.rx.tap
    return ControlEvent(events: source)
  }

  var reorderButtonTap: ControlEvent<Void> {
    let source = base.reorderButton.rx.tap
    return ControlEvent(events: source)
  }

  var doneButtonTap: ControlEvent<Void> {
    let source = base.doneButton.rx.tap
    return ControlEvent(events: source)
  }

}
