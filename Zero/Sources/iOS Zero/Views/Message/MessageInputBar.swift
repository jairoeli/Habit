//
//  MessageInputBar.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class MessageInputBar: UIView {

  // MARK: - Constants

  struct Metric {
    static let padding = 15.f
    static let buttonHeight = 44.f
    static let buttonLeftRight = 32.f
  }

  // MARK: - UI
  fileprivate let textView = UITextView() <== {
    $0.placeholder = "What would you like to do?"
    $0.font = .bold(size: 28)
    $0.isEditable = true
    $0.showsVerticalScrollIndicator = false
    $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
    $0.layer.borderWidth = 1 / UIScreen.main.scale
    $0.layer.cornerRadius = 3
  }

  fileprivate let doneButton = UIButton(type: .system) <== {
    $0.titleLabel?.font = .bold(size: 14)
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.layer.cornerRadius = 4
    $0.backgroundColor = .charcoal
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(self.textView)
    self.addSubview(self.doneButton)

    self.layout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Size

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 150)
  }

  // MARK: - Layout

  fileprivate func layout() {
    self.textView.snp.makeConstraints { (make) in
      make.top.left.equalTo(Metric.padding)
      make.right.equalTo(0).offset(-Metric.padding)
      make.bottom.equalTo(-Metric.padding)
    }

    self.doneButton.snp.makeConstraints { (make) in
      make.top.equalTo(self.textView.snp.bottom).offset(8)
      make.left.equalTo(Metric.buttonLeftRight)
      make.right.equalTo(-Metric.buttonLeftRight)
      make.height.equalTo(Metric.buttonHeight)
      make.width.equalTo(44)
    }
  }

}

// MARK: - Reactive

extension Reactive where Base: MessageInputBar {

  var doneButtonTap: ControlEvent<String> {
    let source: Observable<String> = self.base.doneButton.rx.tap
      .withLatestFrom(self.base.textView.rx.text.asObservable())
      .flatMap { text -> Observable<String> in

        if let text = text, !text.isEmpty {
          return .just(text)
        } else {
          return .empty()
        }
    }
      .do(onNext: { [weak base = self.base] _ in
        base?.textView.text = nil
      })
    return ControlEvent(events: source)
  }

}
