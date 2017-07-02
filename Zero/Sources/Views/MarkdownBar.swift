//
//  MarkdownBar.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/27/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class MarkdownBar: UIView {

  struct Metric {
    static let buttonWidth = 58.f
    static let buttonHeight = 35.f
  }

  // MARK: UI
  fileprivate lazy var toolbar = UIView() <== {
    $0.backgroundColor = .snow
  }

  fileprivate lazy var saveButton = UIButton(type: .system) <== {
    $0.setTitle("Save", for: .normal)
    $0.titleLabel?.font = .black(size: 16)
    $0.setTitleColor(.snow, for: .normal)
    $0.backgroundColor = .redGraphite
    $0.layer.cornerRadius = 4
  }

  fileprivate lazy var cancelButton = UIButton(type: .system) <== {
    $0.setTitle("Cancel", for: .normal)
    $0.setTitleColor(.midGray, for: .normal)
    $0.backgroundColor = .snow
    $0.titleLabel?.font = .black(size: 16)
    $0.layer <== {
      $0.borderWidth = 1
      $0.borderColor = UIColor.platinumBorder.cgColor
      $0.cornerRadius = 4
    }
  }

  var isEnabled: Bool = false {
    didSet {
      self.saveButton.isEnabled = isEnabled
    }
  }

  fileprivate let separatorView = UIView() <== {
    $0.backgroundColor = .platinumBorder
  }

  // MARK: Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.toolbar)
    self.addSubview(self.separatorView)
    self.addSubview(self.saveButton)
    self.addSubview(self.cancelButton)

    self.separatorView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }

    self.toolbar.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.cancelButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(self.saveButton.snp.leading).offset(-8)
      make.width.equalTo(70)
      make.height.equalTo(Metric.buttonHeight)
    }

    self.saveButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.height.equalTo(Metric.buttonHeight)
      make.width.equalTo(Metric.buttonWidth)
      make.trailing.equalTo(-12)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 45)
  }

}

// MARK: - Reactive
extension Reactive where Base: MarkdownBar {

  var saveButtonTap: ControlEvent<Void> {
    let source = base.saveButton.rx.tap
    return ControlEvent(events: source)
  }

  var cancelButtonTap: ControlEvent<Void> {
    let source = base.cancelButton.rx.tap
    return ControlEvent(events: source)
  }

}
