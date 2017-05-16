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
import RxKeyboard
import ReusableKit

final class TaskEditViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Reusable {
    static let habitItemCell = ReusableCell<HabitItemCell>()
  }

  fileprivate struct Metric {
    static let padding = 15.f
    static let buttonWidth = 75.f
  }

  // MARK: - UI

  fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) <== {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
    $0.keyboardDismissMode = .interactive
    $0.register(Reusable.habitItemCell)
    $0.rx.setDataSource(self).disposed(by: self.disposeBag)
    $0.rx.setDelegate(self).disposed(by: self.disposeBag)
    ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
      $0.minimumLineSpacing = 0
    }
  }
  fileprivate let messageInputBar = MessageInputBar()

  fileprivate var messages: [HabitCellReactor] = [
    HabitCellReactor(text: "Test"),
    HabitCellReactor(text: "Do Yoga"),
    HabitCellReactor(text: "Push ups"),
    HabitCellReactor(text: "Walk 20 mintues")
  ]

  lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = .bold(size: 18)
    $0.textColor = .charcoal
    $0.placeholder = "Write your own"
  }

  lazy var doneButtonTap = UIButton(type: .system) <== {
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.charcoal, for: .normal)
    $0.titleLabel?.font = .bold(size: 18)
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
    self.view.backgroundColor = .white

    self.collectionView.contentInset.top = self.messageInputBar.intrinsicContentSize.height
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset

    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.messageInputBar)
    self.view.addSubview(self.titleInput)
    self.view.addSubview(self.doneButtonTap)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.view.endEditing(true)
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
      make.right.equalTo(self.doneButtonTap.snp.left).offset(-4)
    }

    self.doneButtonTap.snp.makeConstraints { make in
      make.centerY.equalTo(self.messageInputBar.snp.centerY)
      make.right.equalTo(-Metric.padding)
      make.width.equalTo(65)
      make.height.equalTo(35)
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
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    keyboardVisibleHeight()
  }

  // MARK: - Keyboard

  fileprivate func keyboardVisibleHeight() {
    // Keyboard
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        self.messageInputBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-keyboardVisibleHeight)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
          self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)

//    RxKeyboard.instance.willShowVisibleHeight
//      .drive(onNext: { [weak self] keyboardVisibleHeight in
//        self?.collectionView.contentOffset.y += keyboardVisibleHeight
//      })
//      .disposed(by: self.disposeBag)
  }

}

// MARK: - UICollectionViewDataSource
extension TaskEditViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(Reusable.habitItemCell, for: indexPath)
    cell.bind(reactor: self.messages[indexPath.item])
    return cell
  }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension TaskEditViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let message = self.messages[indexPath.item]
    return HabitItemCell.size(width: collectionView.width, reactor: message)
  }

}
