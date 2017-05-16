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
    static let sectionInsetLeftRight = 20.f
  }

  // MARK: - Properties

  let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>()

  lazy var addButtonItem = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "add_icon").withRenderingMode(.alwaysOriginal), for: .normal)
  }

  fileprivate let tableView = UITableView() <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.register(Reusable.taskCell)
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
    self.view.addSubview(self.tableView)
    self.view.addSubview(self.addButtonItem)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.showPlusButton()
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.addButtonItem.snp.makeConstraints { make in
      make.bottom.equalTo(Metric.buttonBottom)
      make.centerX.equalToSuperview()
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

    // ACTION
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.addButtonItem.rx.tap
      .map(reactor.reactorForCreatingTask)
      .subscribe(onNext: { [weak self] reactor in
        guard let `self` = self else { return }
        let viewController = TaskEditViewController(reactor: reactor)
        self.present(viewController, animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

}

extension TaskListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    return TaskCell.height(fits: tableView.width, reactor: reactor)
  }

}
