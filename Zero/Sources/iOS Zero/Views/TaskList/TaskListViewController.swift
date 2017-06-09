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

final class TaskListViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }

  fileprivate struct Metric {
    static let buttonSize = 64.f
    static let buttonBottom = 100.f
    static let buttonRight = 20.f
    static let sectionInsetLeftRight = 20.f
  }

  // MARK: - Properties

  let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>()

  lazy var addButtonItem = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "add_icon").withRenderingMode(.alwaysOriginal), for: .normal)
  }

  fileprivate let tableView = UITableView() <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .snow
    $0.separatorStyle = .none
    $0.register(Reusable.taskCell)
  }

  fileprivate lazy var presenter: Presentr = {
    let width = ModalSize.full
    let height = ModalSize.custom(size: 65)
    let originY = self.tableView.frame.height + 45
    let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: originY))
    let customType = PresentationType.custom(width: width, height: height, center: center)

    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = .coverVertical
    customPresenter.dismissTransitionType = .coverVertical
    customPresenter.dismissOnSwipe = true
    customPresenter.keyboardTranslationType = .moveUp

    return customPresenter
  }()

  fileprivate let headerView = SectionHeaderView()

  private lazy var emptyView: EmptyView = {
    let view = EmptyView(frame: .zero)
    view.backgroundColor = .snow
    view.textLabel.text = "Looks like you don't have any tasks."
    return view
  }()

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
//    self.view.addSubview(self.confettiView)
    self.setupEmptyView()
    self.view.addSubview(self.addButtonItem)
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

    self.addButtonItem.snp.makeConstraints { make in
      make.bottom.equalTo(Metric.buttonBottom)
      make.right.equalToSuperview().offset(-Metric.buttonRight)
      make.width.equalTo(Metric.buttonSize)
      make.height.equalTo(Metric.buttonSize)
    }
  }

  fileprivate func showPlusButton() {
    animate(0.5, completion: nil) {
      self.addButtonItem.snp.updateConstraints { make in make.bottom.equalToSuperview().offset(-20) }
      self.addButtonItem.superview?.layoutIfNeeded()
    }
  }

  fileprivate func setupEmptyView() {
    emptyView.addTo(view)
  }

  // MARK: - Binding

  func bind(reactor: TaskListViewReactor) {
    // Datasource
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

//    self.tableView.rx.itemSelected(dataSource: self.dataSource)
//      .map(reactor.reactorForEditingTask)
//      .subscribe(onNext: { [weak self] reactor in
//        guard let `self` = self else { return }
//        let viewController = TaskEditViewController(reactor: reactor)
//        self.customPresentViewController(self.presenter, viewController: viewController, animated: true, completion: nil)
//      })
//      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .map { indexPath in .taskDone(indexPath) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak tableView] indexPath in
        tableView?.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemDeleted
      .map(Reactor.Action.deleteTask)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.addButtonItem.rx.tap
      .map(reactor.reactorForCreatingTask)
      .subscribe(onNext: { [weak self] reactor in
        guard let `self` = self else { return }
        let viewController = TaskEditViewController(reactor: reactor)
        self.customPresentViewController(self.presenter, viewController: viewController, animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    reactor.state.map { !$0.sections.isEmpty }
      .subscribe(onNext: { [weak self] empty in
        self?.emptyView.isHidden = empty ? true : false
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - RxSwift wrapper

  fileprivate func rxViewController() {
    self.rx.viewWillAppear
      .subscribe(onNext: { [weak self] animated in self?.navigationController?.setNavigationBarHidden(true, animated: animated) })
      .disposed(by: self.disposeBag)

    self.rx.viewDidAppear
      .subscribe(onNext: { [weak self] _ in self?.showPlusButton() })
      .disposed(by: self.disposeBag)
  }

}

// MARK: - Table View Delegate
extension TaskListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    return TaskCell.height(fits: tableView.width, reactor: reactor)
  }

}
