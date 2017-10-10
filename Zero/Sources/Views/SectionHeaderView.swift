//
//  SectionHeaderView.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/25/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class SectionHeaderView: UIView {

  struct Metric {
    static let cellPadding = 32.f
    static let leftPadding = 12.f
  }

  // MARK: - UI

  lazy var headerView = UIView() <== {
    $0.backgroundColor = .snow
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.platinumBorder.cgColor
  }
  lazy var yearLabel = UILabel() <== {
    $0.text = "YEAR"
    $0.textColor = .charcoal
    $0.font = .bold(size: 18)
  }

  lazy var progressLabel = UILabel() <== {
    $0.text = "PROGRESS"
    $0.textColor = .charcoal
    $0.font = .bold(size: 18)
  }

  lazy var percentLabel = UILabel() <== {
    $0.text = CalculateProgress.percent()
    $0.textColor = .charcoal
    $0.font = .bold(size: 42)
  }

  lazy var progessResult = UILabel() <== {
    $0.text = CalculateProgress.result()
    $0.font = .bold(size: 14)
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .snow
    let subviews: [UIView] = [headerView, yearLabel, progressLabel, percentLabel, progessResult]
    self.add(subviews)
    self.setUpView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  fileprivate func setUpView() {
    self.headerView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }

    self.yearLabel.snp.makeConstraints { (make) in
      make.top.equalTo(12)
      make.leading.equalTo(12)
    }

    self.progressLabel.snp.makeConstraints { (make) in
      make.top.equalTo(self.yearLabel.snp.bottom)
      make.leading.equalTo(12)
    }

    self.percentLabel.snp.makeConstraints { make in
      make.top.equalTo(9)
      make.trailing.equalTo(-12)
    }

    self.progessResult.snp.makeConstraints { (make) in
      make.top.equalTo(self.progressLabel.snp.bottom).offset(12)
      make.leading.equalTo(14)
    }
  }

  // MARK: - Size

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 100)
  }

}
