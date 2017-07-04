//
//  TaskEditViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/18/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxSwift
import RxKeyboard

final class TaskEditViewController: BaseViewController, View {

  // MARK: - Constants
  struct Metric {
    static let padding = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.title2()
  }

  // MARK: - UI
  lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
  }

  lazy var headerline = UIView() <== {
    $0.backgroundColor = .redGraphite
  }

  lazy var noteInput = UITextView() <== {
    $0.font = .body()
    $0.placeholder = "Add notes..."
    $0.textColor = .charcoal
    $0.tintColor = .redGraphite
    $0.backgroundColor = .snow
  }

  fileprivate let markdownBar = MarkdownBar()

  // MARK: - Initializing
  init(reactor: HabitEditViewReactor) {
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
    let subviews: [UIView] = [titleInput, headerline, noteInput, markdownBar]
    self.view.add(subviews)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleInput.becomeFirstResponder()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.endEditing(true)
  }

  override func setupConstraints() {
    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(30)
      make.leading.equalTo(Metric.padding)
      make.trailing.equalTo(-Metric.padding)
    }

    self.headerline.snp.makeConstraints { make in
      make.top.equalTo(self.titleInput.snp.bottom).offset(12)
      make.leading.equalTo(Metric.padding)
      make.trailing.equalTo(-Metric.padding)
      make.height.equalTo(2)
    }

    self.noteInput.snp.makeConstraints { (make) in
      make.top.equalTo(self.headerline.snp.bottom).offset(12)
      make.leading.equalTo(Metric.padding)
      make.trailing.equalTo(-Metric.padding)
      make.bottom.equalTo(self.markdownBar.snp.top).offset(-8)
    }

    self.markdownBar.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(100)
    }
  }

  // MARK: - Binding
  func bind(reactor: HabitEditViewReactor) {
    // Action
    self.markdownBar.rx.saveButtonTap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.markdownBar.rx.cancelButtonTap
      .map { Reactor.Action.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateHabitTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.noteInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateNote)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxKeyboard()

    // State
    reactor.state.asObservable().map { $0.habitTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.habitNote }
      .distinctUntilChanged()
      .bind(to: self.noteInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] validation in
        guard let `self` = self else { return }
        self.markdownBar.isEnabled = validation
      })
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.isDismissed }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)
  }

  fileprivate func rxKeyboard() {
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        self.markdownBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-keyboardVisibleHeight)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
      })
      .disposed(by: self.disposeBag)

  }

}
