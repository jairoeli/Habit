//
//  TaskEditViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/18/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxSwift

final class TaskEditViewController: BaseViewController, View {

  // MARK: Constants
  struct Metric {
    static let padding = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.title1()
  }

  // MARK: UI
  let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

  let titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = Font.titleLabel
  }

  // MARK: Initializing
  init(reactor: TaskEditViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem
    self.navigationItem.rightBarButtonItem = self.doneButtonItem
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(self.titleInput)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleInput.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.endEditing(true)
  }

  override func setupConstraints() {
    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(Metric.padding)
      make.left.equalTo(Metric.padding)
      make.right.equalTo(-Metric.padding)
    }
  }

  // MARK: Binding
  func bind(reactor: TaskEditViewReactor) {
    // Action
    self.cancelButtonItem.rx.tap
      .map { Reactor.Action.cancel }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.doneButtonItem.rx.tap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButtonItem.rx.isEnabled)
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
