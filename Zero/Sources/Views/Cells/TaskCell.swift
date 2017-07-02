//
//  TaskCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class TaskCell: BaseTableViewCell, View {
  typealias Reactor = TaskCellReactor

  // MARK: - Constants

  struct Constant {
    static let titleLabelNumberOfLines = 2
  }

  struct Metric {
    static let paddingTop = 10.f
    static let padding = 15.f
    static let valueSize = 100.f
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
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.valueLabel)
    self.contentView.addSubview(self.separatorView)
    self.backgroundColor = .snow
  }

  // MARK: - Binding

  func bind(reactor: TaskCellReactor) {
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
    let height = reactor.currentState.title.height(fits: width - Metric.padding,
                                                   font: Font.titleLabel,
                                                   maximumNumberOfLines: Constant.titleLabelNumberOfLines)

    return height + Metric.padding * 4
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()

    self.titleLabel.sizeToFit()
    self.titleLabel.top = Metric.paddingTop
    self.titleLabel.left = Metric.padding
    self.titleLabel.width = self.contentView.width - 130
    self.titleLabel.height = self.contentView.height - 20

    self.valueLabel.sizeToFit()
    self.valueLabel.top = Metric.padding * 2
    self.valueLabel.left = self.titleLabel.right + Metric.padding - Metric.padding
    self.valueLabel.width = Metric.valueSize

    self.separatorView.bottom = self.contentView.bottom
    self.separatorView.left = Metric.padding
    self.separatorView.width = self.contentView.width
    self.separatorView.height = 0.5 / UIScreen.main.scale
  }

}
