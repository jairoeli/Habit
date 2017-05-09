//
//  TaskListViewController.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import ReusableKit
import SnapKit

final class TaskListViewController: BaseViewController, View {

  // MARK: - Constants

  struct Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }

  // MARK: - Properties

  let dataSource = RxCollectionViewSectionedReloadDataSource<TaskListSection>()

  // TODO: Add Button Item

  fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .white
    $0.register(Reusable.taskCell)
  }

  // MARK: - Initializing

  init(reactor: TaskListViewReactor) {
    super.init()
    self.reactor = reactor
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(self.collectionView)
  }

  override func setupConstraints() {
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Binding

  func bind(reactor: TaskListViewReactor) {
    // Datasource
    self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

    self.dataSource.configureCell = { dataSource, collectionView, indexPath, reactor in
      let cell = collectionView.dequeue(Reusable.taskCell, for: indexPath)
      cell.reactor = reactor
      return cell
    }

    // ACTION
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // STATE
    reactor.state.map { $0.sections }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

}

extension TaskListViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
    let reactor = self.dataSource[indexPath]
    return TaskCell.size(width: sectionWidth, reactor: reactor)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

}
