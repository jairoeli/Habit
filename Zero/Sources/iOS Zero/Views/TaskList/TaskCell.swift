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
    static let titleLabel = UIFont.boldSystemFont(ofSize: 24)
  }

  struct Color {
    static let titleLabelText = UIColor.black
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = Color.titleLabelText
    $0.numberOfLines = Constant.titleLabelNumberOfLines
  }

  // MARK: - Initializing

  override func initialize() {
    self.contentView.addSubview(titleLabel)
  }

  // MARK: - Binding

  func bind(reactor: TaskCellReactor) {
    self.titleLabel.text = reactor.currentState.title
    // TODO: add done
  }

  // MARK: - Cell Height

  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    let height = reactor.currentState.title.height(
      fits: width - Metric.cellPadding * 2,
      font: Font.titleLabel,
      maximumNumberOfLines: Constant.titleLabelNumberOfLines
    )

    return height + Metric.cellPadding * 2
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
