//
//  HabitCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/16/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit

final class HabitItemCell: BaseCollectionViewCell, View {

  // MARK: - Constants

  fileprivate struct Metric {
    static let paddingTop = 10.f
    static let paddingBottom = 10.f
    static let paddingLeftRight = 15.f
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.font = .bold(size: 24)
    $0.textColor = .charcoal
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
//    self.backgroundColor = .red
    self.contentView.addSubview(self.titleLabel)
  }

  // MARK: - Binding

  func bind(reactor: HabitCellReactor) {
    reactor.state
      .subscribe(onNext: { [weak self] state in
        self?.titleLabel.text = state.text
      })
      .disposed(by: self.disposeBag)
    self.setNeedsLayout()
  }

  // MARK: - Size

  class func size(width: CGFloat, reactor: HabitCellReactor) -> CGSize {
    guard let textLabel = reactor.currentState.text else { return CGSize(width: width, height: 0) }
    let labelWidth = width - Metric.paddingLeftRight * 2
    let labelHeight = textLabel.height(fits: labelWidth, font: .bold(size: 24))
    return CGSize(width: width, height: labelHeight + Metric.paddingTop + Metric.paddingBottom)
  }

  // MARK: - Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.titleLabel.top = Metric.paddingTop
    self.titleLabel.left = Metric.paddingLeftRight
    self.titleLabel.width = self.contentView.width - Metric.paddingLeftRight * 2
    self.titleLabel.sizeToFit()
  }

}
