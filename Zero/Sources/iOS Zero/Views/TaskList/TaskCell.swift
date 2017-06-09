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
    static let titleLabelNumberOfLines = 0
  }

  struct Metric {
    static let cellPadding = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.black(size: 20)
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.numberOfLines = Constant.titleLabelNumberOfLines
  }

  let valueLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.text = "0"
    $0.textAlignment = .right
  }

  let separatorView = UIView() <== {
    $0.backgroundColor = UIColor(white: 0.85, alpha: 1)
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
    self.titleLabel.text = reactor.currentState.title
    self.titleLabel.textColor = reactor.currentState.isDone ? .silver : .charcoal
    self.valueLabel.text = "\(reactor.currentState.value)"
  }

  // MARK: - Cell Height

  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    let height = reactor.currentState.title
      .height(fits: width - Metric.cellPadding * 4, font: Font.titleLabel, maximumNumberOfLines: Constant.titleLabelNumberOfLines)

    return height + Metric.cellPadding * 4
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()

    self.titleLabel.top = Metric.cellPadding * 2
    self.titleLabel.left = Metric.cellPadding
    self.titleLabel.width = self.contentView.width - Metric.cellPadding * 6
    self.titleLabel.sizeToFit()

    self.valueLabel.top = Metric.cellPadding
    self.valueLabel.left = self.contentView.width - Metric.cellPadding * 2
    self.valueLabel.sizeToFit()
    self.valueLabel.frame = CGRect(x: self.contentView.width - Metric.cellPadding, y: 0, width: -100, height: self.bounds.size.height)

    self.separatorView.bottom = self.contentView.bottom
    self.separatorView.left = Metric.cellPadding
    self.separatorView.width = self.contentView.width - Metric.cellPadding * 2
    self.separatorView.height = 0.5 / UIScreen.main.scale
  }

}
