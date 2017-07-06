//
//  SettingsViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import SafariServices
import UIKit
import ReactorKit
import ReusableKit
import RxDataSources

final class SettingsViewController: BaseViewController, View {

  // MARK: - Constants

  fileprivate struct Reusable {
    static let cell = ReusableCell<SettingItemCell>()
  }

  // MARK: Properties

  fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SettingsViewSection>()

  // MARK: UI
  fileprivate lazy var tableView = UITableView(frame: .zero, style: .grouped) <== {
    $0.register(Reusable.cell)
  }

  // MARK: Initializing

  init(reactor: SettingsViewReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.title = "Settings"
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.tableView)
  }

  override func setupConstraints() {
    self.tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Binding

  func bind(reactor: SettingsViewReactor) {
    self.dataSource.configureCell = { dataSource, tableView, indexPath, sectionItem in
      let cell = tableView.dequeue(Reusable.cell, for: indexPath)

      switch sectionItem {
      case .version(let reactor):
        cell.reactor = reactor

      case .github(let reactor):
        cell.reactor = reactor

      case .icons(let reactor):
        cell.reactor = reactor
      }

      return cell
    }

    // State
    reactor.state.map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    // View
    self.tableView.rx.itemSelected(dataSource: self.dataSource)
      .subscribe(onNext: { [weak self] sectionItem in
        guard let `self` = self else { return }
        switch sectionItem {
        case .version:
          let reactor = VersionViewReactor(provider: reactor.provider)
          let viewController = VersionViewController(reactor: reactor)
          self.navigationController?.pushViewController(viewController, animated: true)

        case .github:
          let url = URL(string: "https://github.com/jairoeli/Zero")!
          let viewController = SFSafariViewController(url: url)
          self.present(viewController, animated: true, completion: nil)

        case .icons:
          let url = URL(string: "https://nucleoapp.com")!
          let viewController = SFSafariViewController(url: url)
          self.present(viewController, animated: true, completion: nil)
        }
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak tableView] indexPath in
        tableView?.deselectRow(at: indexPath, animated: false)
      })
      .disposed(by: self.disposeBag)

  }

}
