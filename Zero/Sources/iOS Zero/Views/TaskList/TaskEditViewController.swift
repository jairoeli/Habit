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

final class TaskEditViewController: BaseViewController, View {

  // MARK: - Constants

  struct Metric {
    static let padding = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.bold(size: 28)
  }

  // MARK: - UI

  lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = Font.titleLabel
    $0.placeholder = "What would you like to do?"
  }

  fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) <== {
    $0.backgroundColor = .clear
  }
  fileprivate let messageInputBar = MessageInputBar()

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

    self.collectionView.contentInset.bottom = self.messageInputBar.intrinsicContentSize.height
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset

    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.messageInputBar)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.becomeFirstResponder()
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { (make) in make.edges.equalToSuperview() }

    self.messageInputBar.snp.makeConstraints { (make) in
      make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(4)
      make.left.right.equalTo(0)
//      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
    }
  }

  // MARK: - Binding

  func bind(reactor: TaskEditViewReactor) {
    // ACTION
//    self.titleInput.rx.text
//      .filterNil()
//      .map(Reactor.Action.updateTaskTitle)
//      .bind(to: reactor.action)
//      .disposed(by: self.disposeBag)


    // STATE
    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
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
