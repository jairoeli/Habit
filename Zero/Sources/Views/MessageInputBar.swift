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

  private let disposeBag = DisposeBag()

  fileprivate struct Metric {
    static let padding = 15.f
    static let buttonWidth = 58.f
    static let buttonHeight = 35.f
  }

  var doneButtonColor: UIColor? {
    didSet {
      self.doneButton.setTitleColor(.midGray, for: .normal)
      self.doneButton.layer.borderColor = UIColor.platinumBorder.cgColor
      self.doneButton.backgroundColor = .snow
      self.doneButton.isEnabled = false
    }
  }

  // MARK: - UI

  fileprivate lazy var textView = UIView() <== {
    $0.backgroundColor = .snow
  }

  fileprivate lazy var separatorView = UIView() <== {
    $0.backgroundColor = .platinumBorder
  }

  fileprivate lazy var smileyButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "smiley").withRenderingMode(.alwaysTemplate), for: .normal)
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
    let subviews: [UIView] = [textView, separatorView, smileyButton, doneButton]
    self.add(subviews)
    self.setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 60)
  }

  // MARK: - Layout

  func setupLayout() {
    self.textView.snp.makeConstraints { make in make.edges.equalToSuperview() }

    self.separatorView.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(1 / UIScreen.main.scale)
    }

    self.smileyButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(2)
      make.size.equalTo(44)
    }

    self.doneButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.right.equalTo(-Metric.padding)
      make.width.equalTo(Metric.buttonWidth)
      make.height.equalTo(Metric.buttonHeight)
    }
  }
}

// MARK: - Reactive
extension Reactive where Base: MessageInputBar {

  var doneButtonTap: ControlEvent<Void> {
    let source = base.doneButton.rx.tap
    return ControlEvent(events: source)
  }

  var isEnabled: Binder<Bool> {
    return Binder(self.base) { view, enabled in
      view.doneButton.isEnabled = enabled ? true : false
      view.doneButton.backgroundColor = enabled ? .redGraphite : .snow
      view.doneButton.layer.borderColor = enabled ? UIColor.redGraphite.cgColor : UIColor.platinumBorder.cgColor
      view.doneButton.setTitleColor(enabled ? .snow : .midGray, for: .normal)
    }
  }

}
