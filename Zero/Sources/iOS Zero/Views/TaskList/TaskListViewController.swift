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

final class TaskListViewController: BaseViewController, View {

  // MARK: - Constants

  struct Reusable {
    static let taskCell = ReusableCell<TaskCell>()
  }

  // MARK: - Properties

  let dataSource = RxCollectionViewSectionedReloadDataSource<TaskListSection>()

  lazy var addButtonItem = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "add_icon").withRenderingMode(.alwaysOriginal), for: .normal)
  }

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
    self.collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.addButtonItem.snp.makeConstraints { make in
      make.bottom.equalTo(100)
      make.centerX.equalToSuperview()
      make.width.equalTo(64)
      make.height.equalTo(64)
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
    self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

    self.dataSource.configureCell = { dataSource, collectionView, indexPath, reactor in
      let cell = collectionView.dequeue(Reusable.taskCell, for: indexPath)
      cell.reactor = reactor
      return cell
    }
    self.dataSource.canMoveItemAtIndexPath = { _ in true }

    // ACTION
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

//    self.collectionView.rx.swipeGesture(.left)
//      .when(.recognized)
//      .subscribe(onNext: { _ in
//        self.view.backgroundColor = .red
//      })
//      .disposed(by: self.disposeBag)

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
