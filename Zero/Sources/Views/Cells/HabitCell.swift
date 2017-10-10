//
//  HabitCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class HabitCell: BaseTableViewCell, View {
  typealias Reactor = HabitCellReactor

  // MARK: - Constants

  struct Constant {
    static let titleLabelNumberOfLines = 0
  }

  struct Metric {
    static let paddingTop = 24.f
    static let padding = 16.f
    static let valueSize = 85.f
  }

  struct Font {
    static let titleLabel = UIFont.title2()
  }

  // MARK: - UI

  lazy var titleLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.numberOfLines = Constant.titleLabelNumberOfLines
  }

  lazy var valueLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.text = "0"
    $0.textAlignment = .right
  }

  lazy var separatorView = UIView() <== {
    $0.backgroundColor = .platinumBorder
  }

  // MARK: - Initializing

  override func initialize() {
    let subviews: [UIView] = [titleLabel, valueLabel, separatorView]
    self.contentView.add(subviews)
    self.backgroundColor = .snow
  }

  // MARK: - Binding

  func bind(reactor: HabitCellReactor) {
    reactor.state.map { $0.title }
      .distinctUntilChanged()
      .bind(to: self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { "\($0.value)" }
      .bind(to: self.valueLabel.rx.text)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Cell Height

  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    let height = reactor.currentState.title.height(fits: width - Metric.paddingTop * 3,
                                                   font: Font.titleLabel,
                                                   maximumNumberOfLines: Constant.titleLabelNumberOfLines)

    return height + Metric.padding * 3
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()

    self.titleLabel.sizeToFit()
    self.titleLabel.top = Metric.paddingTop
    self.titleLabel.left = Metric.padding
    self.titleLabel.width = self.contentView.width - 100

    self.valueLabel.sizeToFit()
    self.valueLabel.centerY = self.contentView.centerY
    self.valueLabel.left = self.titleLabel.right - 16
    self.valueLabel.width = Metric.valueSize

    self.separatorView.bottom = self.contentView.bottom
    self.separatorView.left = Metric.padding
    self.separatorView.width = self.contentView.width - Metric.padding * 2
    self.separatorView.height = 0.5 / UIScreen.main.scale
  }

}
