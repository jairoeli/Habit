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
import Presentr

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

  let dataSource = RxCollectionViewSectionedReloadDataSource<TaskListSection>()

  lazy var addButtonItem = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "add_icon").withRenderingMode(.alwaysOriginal), for: .normal)
  }

  fileprivate let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) <== {
    $0.alwaysBounceVertical = true
    $0.backgroundColor = .white
    $0.register(Reusable.taskCell)
  }

  fileprivate let presenter: Presentr = {
    let width = ModalSize.full
    let height = ModalSize.half
    let center = ModalCenterPosition.bottomCenter
    let customType = PresentationType.custom(width: width, height: height, center: center)

    let customPresenter = Presentr(presentationType: customType)
    customPresenter.transitionType = TransitionType.coverHorizontalFromRight
    customPresenter.dismissOnSwipe = true
    customPresenter.transitionType = nil
    customPresenter.dismissTransitionType = nil
    customPresenter.keyboardTranslationType = .moveUp
    return customPresenter
  }()

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

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: Metric.sectionInsetLeftRight, bottom: 0, right: Metric.sectionInsetLeftRight)
  }

}
