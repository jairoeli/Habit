//
//  HabitListViewController.swift
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
import SwipeCellKit

final class HabitListViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Reusable {
    static let habitCell = ReusableCell<HabitCell>()
  }

  fileprivate struct Metric {
    static let padding = 15.f
    static let iconViewTop = 0.f
    static let iconViewSize = 130.f
    static let iconViewBottom = 0.f
  }

  // MARK: - Properties
  var isSwipeRightEnabled = true
  var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
  var buttonStyle: ButtonStyle = .backgroundColor

  let dataSource = RxTableViewSectionedReloadDataSource<HabitListSection>()
  fileprivate let messageInputBar = MessageInputBar()
  fileprivate let headerView = SectionHeaderView()

  fileprivate lazy var tableView = UITableView() <== {
    $0.register(Reusable.habitCell)
    $0.alwaysBounceVertical = false
    $0.backgroundColor = .snow
    $0.separatorStyle = .none
    $0.keyboardDismissMode = .interactive
    $0.allowsSelectionDuringEditing = false
    $0.estimatedRowHeight = 75.0
    $0.rowHeight = UITableViewAutomaticDimension
    $0.reorder.delegate = self
  }

  fileprivate lazy var titleInput = UITextField() <== {
    $0.font = .title3()
    $0.textColor = .charcoal
    $0.placeholder = "Add a new goal..."
    $0.tintColor = .azure
  }

  let settingButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: nil, action: nil)

  // MARK: - Initializing

  init(reactor: HabitListViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.title = "2017"
    self.navigationItem.rightBarButtonItem = self.settingButtonItem
    if #available(iOS 11.0, *) { self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic }
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.contentInset.top = Metric.iconViewSize
    self.tableView.addSubview(self.headerView)
    let subviews: [UIView] = [tableView, messageInputBar, titleInput]
    self.view.add(subviews)
    titleInput.delegate = self
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.bottom.equalTo(self.safeAreaBottom)
    }

    self.headerView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(-115)
      make.centerX.equalToSuperview()
      make.leading.equalTo(15)
    }

    self.messageInputBar.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      make.bottom.equalTo(self.safeAreaBottom)
    }

    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.messageInputBar.snp.top).offset(18)
      make.leading.equalTo(50)
      make.trailing.equalTo(-Metric.padding * 5)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if self.tableView.contentInset.bottom == 0 {
      self.tableView.contentInset.bottom = self.messageInputBar.height
      self.tableView.scrollIndicatorInsets.bottom = self.tableView.contentInset.bottom
    }
  }

  // MARK: - Binding
  // swiftlint:disable function_body_length
  func bind(reactor: HabitListViewReactor) {
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)

    self.dataSource.configureCell = { _, tableView, indexPath, reactor in
      if let spacer = tableView.reorder.spacerCell(for: indexPath) {
        return spacer
      }
      let cell = tableView.dequeue(Reusable.habitCell, for: indexPath)
      cell.selectionStyle = .none
      cell.delegate = self
      cell.reactor = reactor
      return cell
    }

    self.dataSource.canEditRowAtIndexPath = { _, _ in return true }
    self.dataSource.canMoveRowAtIndexPath = { _, _ in return true }

    let wasReachedBottom: Observable<Bool> = self.tableView.rx.contentOffset
      .map { [weak self] _ in
        self?.tableView.isReachedBottom() ?? false
    }

    // ACTION
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxViewController()

    self.titleInput.rx.text
      .filterNil()
      .map(Reactor.Action.updateHabitTitle)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.titleInput.rx.text.orEmpty
      .map { !$0.isEmpty }
      .bind(to: self.messageInputBar.rx.isEnabled)
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.doneButtonTap
      .map { Reactor.Action.submit }
      .do(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.titleInput.text = nil
        self.messageInputBar.doneButtonColor = .midGray
      })
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.settingButtonItem.rx.tap
      .map { reactor.settingsViewReactor() }
      .subscribe(onNext: { [weak self] reactor in
        let controller = SettingsViewController(reactor: reactor)
        let navController = UINavigationController(rootViewController: controller)
        self?.present(navController, animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .debounce(0.2, scheduler: MainScheduler.instance)
      .map { indexPath in .habitIncreaseValue(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxKeyboard()

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .debounce(0.1, scheduler: MainScheduler.instance)
      .withLatestFrom(wasReachedBottom) { ($0, $1) }
      .filter { _, wasReachedBottom in wasReachedBottom == true }
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.scrollToBottom(animated: true)
      })
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.habitTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.messageInputBar.rx.isEnabled)
      .disposed(by: self.disposeBag)
  }
  // swiftlint:enable function_body_length

}

// MARK: - Table View Delegate
extension HabitListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    return HabitCell.height(fits: tableView.width, reactor: reactor)
  }

}
// MARK: - Reorder
extension HabitListViewController: TableViewReorderDelegate {
  func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    self.reactor?.action.onNext(Reactor.Action.moveHabit(sourceIndexPath, destinationIndexPath))
  }
}

// MARK: - Reactive wrapper
extension HabitListViewController {
  fileprivate func rxViewController() {
    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak tableView] indexPath in
        tableView?.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [weak self] _ in
        self?.titleInput.becomeFirstResponder()
      })
      .disposed(by: self.disposeBag)
  }

  fileprivate func rxKeyboard() {
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] keyboardVisibleHeight in
        guard let `self` = self, self.didSetupConstraints else { return }
        var actualKeyboardHeight = keyboardVisibleHeight
        if #available(iOS 11.0, *), keyboardVisibleHeight > 0 {
          actualKeyboardHeight -= self.view.safeAreaInsets.bottom
        }

        self.messageInputBar.snp.updateConstraints { make in
          make.bottom.equalTo(self.safeAreaBottom).offset(-actualKeyboardHeight)
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
