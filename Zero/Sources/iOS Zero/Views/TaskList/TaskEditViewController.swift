//
//  TaskEditViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxKeyboard
import Presentr

final class TaskEditViewController: BaseViewController, View {

  // MARK: - Constants

  struct Metric {
    static let padding = 15.f
    static let buttonHeight = 44.f
    static let buttonLeftRight = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.bold(size: 18)
  }

  // MARK: - UI

  fileprivate let collectionView = UICollectionView(frame: .zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout()) <== {
      $0.backgroundColor = .clear
//      $0.alwaysBounceVertical = true
      $0.keyboardDismissMode = .interactive
  }

  lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = Font.titleLabel
    $0.placeholder = "What would you like to do?"
  }

  lazy var doneButton = UIButton(type: .system) <== {
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .charcoal
    $0.layer.cornerRadius = 4
  }

  lazy var cancelButton = UIButton(type: .system) <== {
    $0.setTitle("Cancel", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .charcoal
    $0.layer.cornerRadius = 4
  }

  // MARK: - Initializing

  init(reactor: TaskEditViewReactor) {
    super.init()
    self.reactor = reactor
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    self.collectionView.contentInset.top = self.titleInput.intrinsicContentSize.height
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset

    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.titleInput)
    self.view.addSubview(self.doneButton)
    self.view.addSubview(self.cancelButton)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleInput.becomeFirstResponder()
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(Metric.padding)
      make.left.equalTo(Metric.padding)
      make.right.equalTo(-Metric.padding)
//      make.height.equalTo(60)
    }

    self.cancelButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
      make.left.equalTo(Metric.buttonLeftRight)
      make.right.equalTo(self.doneButton.snp.left).offset(-10)
      make.height.equalTo(Metric.buttonHeight)
    }

    self.doneButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
      make.left.equalTo(self.cancelButton.snp.right)
      make.right.equalTo(-Metric.buttonLeftRight)
      make.size.equalTo(self.cancelButton)
    }

  }

  // MARK: - Binding

  func bind(reactor: TaskEditViewReactor) {
    // ACTION
    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.doneButton.rx.tap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.cancelButton.rx.tap
      .map { Reactor.Action.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButton.rx.isEnabled)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.isDismissed }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)
  }

}

// MARK: - Presentr Delegate

extension TaskEditViewController: PresentrDelegate {

  func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
    return keyboardShowing
  }

}
