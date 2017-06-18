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
    static let cellPadding = 30.f
    static let leftPadding = 15.f
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.text = TimeOfTheDay.getGreetingFromTheCurrentOfTheDay()
    $0.textColor = .charcoal
    $0.font = .black(size: 32)
  }

  let displayDate = UILabel() <== {
    let date = Date()
    $0.text =  date.currentDate()
    $0.textColor = .midGray
    $0.font = .footnote()
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .snow

    self.addSubview(self.titleLabel)
    self.addSubview(self.displayDate)
    self.setUpView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  fileprivate func setUpView() {
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.displayDate.snp.bottom).offset(2)
      make.left.equalTo(Metric.leftPadding)
    }

    self.displayDate.snp.makeConstraints { make in
      make.top.equalTo(Metric.cellPadding)
      make.left.equalTo(Metric.leftPadding)
    }
  }

  // MARK: - Size

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 100)
  }

}
