//
//  TaskListViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//
import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import ReusableKit
import RxKeyboard

final class TaskListViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }

  fileprivate struct Metric {
    static let padding = 15.f
    static let buttonWidth = 65.f
    static let buttonHeight = 35.f
    static let buttonRight = 4.f
  }

  // MARK: - Properties

  let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>()

  fileprivate let tableView = UITableView() <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .snow
    $0.separatorStyle = .none
    $0.keyboardDismissMode = .interactive
    $0.showsVerticalScrollIndicator = false
    $0.register(Reusable.taskCell)
  }
  fileprivate let headerView = SectionHeaderView()

  fileprivate lazy var titleInput = UITextField() <== {
    $0.autocorrectionType = .no
    $0.font = .black(size: 18)
    $0.textColor = .charcoal
    $0.placeholder = "Add a new goal"
    $0.tintColor = .redGraphite
  }
  fileprivate let messageInputBar = MessageInputBar()

  fileprivate lazy var doneButtonTap = UIButton(type: .system) <== {
    $0.setTitle("Done", for: .normal)
    $0.setTitleColor(.redGraphite ~ 50%, for: .normal)
    $0.titleLabel?.font = .black(size: 18)
  }

  // MARK: - Initializing

  init(reactor: TaskListViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.headerView)
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.messageInputBar)
    self.view.addSubview(self.titleInput)
    self.view.addSubview(self.doneButtonTap)
    self.tableView.contentInset.bottom = self.messageInputBar.intrinsicContentSize.height
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset
    self.tableView.contentInset = UIEdgeInsets(top: 0.f, left: 0.f, bottom: 65.f, right: 0.f)
    self.titleInput.delegate = self
  }

  override func setupConstraints() {
    self.headerView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
    }

    self.tableView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.snp.bottom)
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }

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
  // swiftlint:disable function_body_length
  func bind(reactor: TaskListViewReactor) {
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)

    self.dataSource.configureCell = { _, tableView, indexPath, reactor in
      let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
      cell.selectionStyle = .none
      cell.reactor = reactor
      return cell
    }
    self.dataSource.canEditRowAtIndexPath = { _ in true }

    // ACTION
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxViewController()

    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateTaskTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.titleInput.rx.text
      .map { $0?.isEmpty == false }
      .subscribe(onNext: { [weak self] isValid in
        guard let `self` = self else { return }
        self.doneButtonTap.isEnabled = isValid
        self.doneButtonTap.titleLabel?.textColor = isValid ? .redGraphite : .redGraphite ~ 50%
      })
      .disposed(by: self.disposeBag)

    self.doneButtonTap.rx.tap
      .map { Reactor.Action.submit }
      .do(onNext: { [weak self] _ in self?.titleInput.text = nil })
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .map { indexPath in .taskIncreaseValue(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemDeleted
      .map(Reactor.Action.deleteTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.taskTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.doneButtonTap.rx.isEnabled)
      .disposed(by: self.disposeBag)

    // Keyboard
    self.rxKeyboard()
  }

}

// MARK: - Table View Delegate
extension TaskListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    return TaskCell.height(fits: tableView.width, reactor: reactor)
  }

}

// MARK: - RxSwift wrapper
extension TaskListViewController {
  fileprivate func rxViewController() {
    self.rx.viewWillAppear
      .subscribe(onNext: { [weak self] animated in
        self?.navigationController?.setNavigationBarHidden(true, animated: animated)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak tableView] indexPath in
        tableView?.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.tapGesture(numberOfTapsRequired: 2)
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: self.disposeBag)
  }

  fileprivate func rxKeyboard() {
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        self.messageInputBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-keyboardVisibleHeight)
        }
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0) {
          self.tableView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
          self.tableView.scrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
          self.view.layoutIfNeeded()
        }
      })
      .disposed(by: self.disposeBag)

    RxKeyboard.instance.willShowVisibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        self?.tableView.contentOffset.y += keyboardVisibleHeight
      })
      .disposed(by: self.disposeBag)
  }
}
