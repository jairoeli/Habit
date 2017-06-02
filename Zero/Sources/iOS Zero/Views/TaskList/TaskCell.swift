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
    static let titleLabel = UIFont.black(size: 24)
  }

  // MARK: - UI

  fileprivate let cardView = UIImageView() <== {
    $0.image = UIImage.resizable()
      .border(color: .platinumBorder)
      .border(width: 2 / UIScreen.main.scale)
      .corner(radius: 2)
      .color(.snow)
      .image
  }

  fileprivate let tagView = UIImageView() <== {
    $0.image = UIImage.resizable()
      .color(.redGraphite)
      .corner(topLeft: 2)
      .corner(bottomLeft: 2)
      .image
    $0.layer.masksToBounds = true
  }

  let titleLabel = UILabel() <== {
    $0.font = Font.titleLabel
    $0.textColor = .charcoal
    $0.numberOfLines = Constant.titleLabelNumberOfLines
  }

  // MARK: - Initializing

  override func initialize() {
    self.contentView.addSubview(self.cardView)
    self.cardView.addSubview(self.titleLabel)
    self.cardView.addSubview(self.tagView)
  }

  // MARK: - Binding

  func bind(reactor: TaskCellReactor) {
    self.titleLabel.text = reactor.currentState.title
  }

  // MARK: - Cell Height

  class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
    let height =  reactor.currentState.title.height(
      fits: width - Metric.cellPadding * 2,
      font: Font.titleLabel,
      maximumNumberOfLines: Constant.titleLabelNumberOfLines
    )
    return height + Metric.cellPadding * 2
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    self.cardView.frame = self.contentView.bounds
    self.cardView.left = Metric.cellPadding
    self.cardView.width = self.contentView.width - Metric.cellPadding * 2

    self.tagView.left = 0
    self.tagView.width = 4
    self.tagView.height = self.cardView.height

    self.titleLabel.top = Metric.cellPadding
    self.titleLabel.left = Metric.cellPadding
    self.titleLabel.width = self.cardView.width - Metric.cellPadding * 2
    self.titleLabel.sizeToFit()
  }

}
