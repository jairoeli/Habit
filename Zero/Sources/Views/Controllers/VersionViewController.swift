//
//  VersionViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 7/3/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import ReusableKit

class VersionViewController: BaseViewController, View {

  // MARK: Constants
  fileprivate struct Reusable {
    static let cell = ReusableCell<VersionCell>()
  }

  fileprivate struct Metric {
    static let iconViewTop = 20.f
    static let iconViewSize = 100.f
    static let iconViewBottom = 0.f
  }

  // MARK: UI
  fileprivate let iconView = UIView() <== {
    $0.layer <== {
      $0.backgroundColor = UIColor.redGraphite.cgColor
      $0.borderColor = 0xE5E5E5.color.cgColor
      $0.borderWidth = 1
      $0.cornerRadius = Metric.iconViewSize * 13.5 / 60
      $0.minificationFilter = kCAFilterTrilinear
    }
    $0.clipsToBounds = true
  }

  fileprivate let tableView = UITableView(frame: .zero, style: .grouped) <== {
    $0.alwaysBounceVertical = false
    $0.register(Reusable.cell)
    $0.backgroundColor = .snow
  }

  // MARK: Initializing
  init(reactor: VersionViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.title = "Version"
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .snow
    self.tableView.dataSource = self
    self.tableView.contentInset.top = Metric.iconViewTop + Metric.iconViewSize + Metric.iconViewBottom
    self.tableView.addSubview(self.iconView)
    self.view.addSubview(self.tableView)
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.iconView.snp.makeConstraints { make in
      if #available(iOS 11.0, *) {
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
      } else {
        make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(12)
      }
      make.centerX.equalToSuperview()
      make.size.equalTo(Metric.iconViewSize)
    }
  }

  // MARK: Binding
  func bind(reactor: VersionViewReactor) {
    // Action
    self.rx.viewWillAppear
      .map { _ in Reactor.Action.checkForUpdates }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      })
      .disposed(by: self.disposeBag)
  }

}

extension VersionViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
    if indexPath.row == 0 {
      cell.textLabel?.text = "Current version"
      cell.detailTextLabel?.text = self.reactor?.currentState.currentVersion
      cell.isLoading = false
    } else {
      cell.textLabel?.text = "Latest version"
      cell.detailTextLabel?.text = self.reactor?.currentState.latestVersion
      cell.isLoading = self.reactor?.currentState.isLoading ?? false
    }
    return cell
  }

}
