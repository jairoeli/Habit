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
import RxCocoa
import Presentr

final class TaskEditViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Metric {
    static let padding = 15.f
    static let buttonWidth = 65.f
    static let buttonHeight = 35.f
    static let buttonRight = 4.f
  }

  // MARK: - UI

  fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) <== {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
  }
  fileprivate let messageInputBar = MessageInputBar()

  fileprivate lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = .black(size: 18)
    $0.textColor = .charcoal
    $0.placeholder = "Add a new task"
    $0.tintColor = .redGraphite
  }

   fileprivate lazy var doneButtonTap = UIButton(type: .system) <== {
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.redGraphite ~ 50%, for: .normal)
    $0.titleLabel?.font = .black(size: 18)
  }

  // MARK: - Initializing

  init(reactor: TaskEditViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .snow

    self.collectionView.contentInset.top = self.messageInputBar.intrinsicContentSize.height
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset

    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.messageInputBar)
    self.view.addSubview(self.titleInput)
    self.view.addSubview(self.doneButtonTap)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in make.edges.equalToSuperview() }

    self.messageInputBar.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
    }

    self.titleInput.snp.makeConstraints { make in
      make.centerY.equalTo(self.messageInputBar.snp.centerY).offset(-0.5)
      make.left.equalTo(Metric.padding)
      make.right.equalTo(self.doneButtonTap.snp.left).offset(-Metric.buttonRight)
    }

    self.doneButtonTap.snp.makeConstraints { make in
      make.centerY.equalTo(self.messageInputBar.snp.centerY)
      make.right.equalTo(-Metric.padding)
      make.width.equalTo(Metric.buttonWidth)
      make.height.equalTo(Metric.buttonHeight)
    }

  }

  // MARK: - Binding

  func bind(reactor: TaskEditViewReactor) {

    // ACTION
    self.rxViewController()

    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // swiftlint:disable empty_count
    self.titleInput.rx.text.orEmpty
      .map { $0.characters.count >= 0 }
      .shareReplay(1)
      .subscribe(onNext: { [weak self] isValid in
        guard let `self` = self else { return }
        self.doneButtonTap.isEnabled = isValid
        self.doneButtonTap.titleLabel?.textColor = isValid ? .redGraphite : .redGraphite ~ 50%
      })
      .disposed(by: self.disposeBag)

    self.doneButtonTap.rx.tap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButtonTap.rx.isEnabled)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.isDismissed }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

  }

  fileprivate func rxViewController() {
    self.rx.viewDidAppear
      .subscribe(onNext: { [weak self] _ in self?.titleInput.becomeFirstResponder() })
      .disposed(by: self.disposeBag)

    self.rx.viewWillDisappear
      .subscribe(onNext: { [weak self] _ in self?.view.endEditing(true) })
      .disposed(by: self.disposeBag)
  }

}

// MARK: - Presentr Delegate
extension TaskEditViewController: PresentrDelegate {

  func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
    return keyboardShowing
  }

}

// MARK: - UITextField Delegate

extension TaskEditViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

}
