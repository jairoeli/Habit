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
  }

  // MARK: - Properties
  var isSwipeRightEnabled = true
  var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
  var buttonStyle: ButtonStyle = .backgroundColor

  let dataSource = RxTableViewSectionedReloadDataSource<HabitListSection>()
  fileprivate let headerView = SectionHeaderView()
  fileprivate let messageInputBar = MessageInputBar()
  fileprivate lazy var tableView = UITableView() <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .snow
    $0.separatorStyle = .none
    $0.keyboardDismissMode = .onDrag
    $0.allowsSelectionDuringEditing = true
    $0.register(Reusable.habitCell)
  }

  fileprivate lazy var titleInput = UITextField() <== {
    $0.font = .title3()
    $0.textColor = .charcoal
    $0.placeholder = "Add a new goal..."
    $0.tintColor = .redGraphite
  }

  // MARK: - Initializing

  init(reactor: HabitListViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    let subviews: [UIView] = [headerView, tableView, messageInputBar, titleInput]
    self.view.add(subviews)

    tableView.contentInset.bottom = self.messageInputBar.intrinsicContentSize.height
    tableView.scrollIndicatorInsets = self.tableView.contentInset
    tableView.contentInset = UIEdgeInsets(top: 0.f, left: 0.f, bottom: 85.f, right: 0.f)
    titleInput.delegate = self
  }

  override func setupConstraints() {
    self.headerView.snp.makeConstraints { make in make.top.left.right.equalToSuperview() }

    self.tableView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }

    self.messageInputBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
    }

    self.titleInput.snp.makeConstraints { make in
      make.top.equalTo(self.messageInputBar.snp.top).offset(10)
      make.leading.equalTo(Metric.padding)
      make.trailing.equalTo(-Metric.padding)
    }
  }

  // MARK: - Binding
  // swiftlint:disable function_body_length
  func bind(reactor: HabitListViewReactor) {
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)

    self.dataSource.configureCell = { _, tableView, indexPath, reactor in
      let cell = tableView.dequeue(Reusable.habitCell, for: indexPath)
      cell.selectionStyle = .none
      cell.delegate = self
      cell.reactor = reactor
      return cell
    }
    self.dataSource.canEditRowAtIndexPath = { _ in true }
    self.dataSource.canMoveRowAtIndexPath = { _ in true }

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
      .subscribe(onNext: { [weak self] validation in
        guard let `self` = self else { return }
        self.messageInputBar.isEnabled = validation
        self.messageInputBar.buttonColor = validation ? .redGraphite : .snow
        self.messageInputBar.borderColor = validation ? .redGraphite : .platinumBorder
        self.messageInputBar.buttonTitleColor = validation ? .snow : .midGray
      })
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.doneButtonTap
      .map { Reactor.Action.submit }
      .do(onNext: { [weak self] _ in
        guard let `self` = self else { return }
        self.titleInput.text = nil
        self.messageInputBar.isEnabled = false
        self.messageInputBar.buttonColor = .snow
        self.messageInputBar.borderColor = .platinumBorder
        self.messageInputBar.buttonTitleColor = .midGray
      })
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.reorderButtonTap
      .map { Reactor.Action.toggleEditing }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.messageInputBar.rx.settingsButtonTap
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

    self.tableView.rx.itemMoved
      .map(Reactor.Action.moveHabit)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxKeyboard()

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.habitTitle }
      .distinctUntilChanged()
      .bind(to: self.titleInput.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.canSubmit }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] validation in
        guard let `self` = self else { return }
        self.messageInputBar.isEnabled = validation
      })
      .disposed(by: self.disposeBag)

    reactor.state.asObservable().map { $0.isMoving }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isEditing in
        guard let `self` = self else { return }
        self.messageInputBar.tintColor = isEditing ? .redGraphite : .midGray
        self.tableView.setEditing(isEditing, animated: true)
      })
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

// MARK: - Reactive wrapper
extension HabitListViewController {
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
