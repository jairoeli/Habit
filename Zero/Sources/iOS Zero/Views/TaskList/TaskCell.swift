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

final class TaskCell: BaseCollectionViewCell, View {
  typealias Reactor = TaskCellReactor

  // MARK: - Constants

  struct Constant {
    static let titleLabelNumberOfLines = 2
  }

  struct Metric {
    static let cellPadding = 15.f
  }

  struct Font {
    static let titleLabel = UIFont.bold(size: 24)
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.numberOfLines = Constant.titleLabelNumberOfLines
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .slate
    self.layer.cornerRadius = 4
    self.contentView.addSubview(titleLabel)
  }

  // MARK: - Binding

  func bind(reactor: TaskCellReactor) {
    self.titleLabel.text = reactor.currentState.title
    // TODO: add done
  }

  // MARK: - Size

  class func size(width: CGFloat, reactor: Reactor) -> CGSize {
    let titleLabelWidth = width - Metric.cellPadding * 2
    let titleLabelHeight = reactor.currentState.title.height(fits: titleLabelWidth, font: Font.titleLabel, maximumNumberOfLines: Constant.titleLabelNumberOfLines)

    return CGSize(width: width, height: Metric.cellPadding * 2 + titleLabelHeight)
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()

    self.titleLabel.top = Metric.cellPadding
    self.titleLabel.left = Metric.cellPadding
    self.titleLabel.width = self.contentView.width - Metric.cellPadding * 2
    self.titleLabel.sizeToFit()
  }

}
