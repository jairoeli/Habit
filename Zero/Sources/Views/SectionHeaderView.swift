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

  lazy var titleLabel = UILabel() <== {
    $0.text = TimeOfTheDay.getGreetingFromTheCurrentOfTheDay()
    $0.textColor = .charcoal
    $0.font = .black(size: 32)
  }

  lazy var displayDate = UILabel() <== {
    let date = Date()
    $0.text =  date.currentDate()
    $0.textColor = .midGray
    $0.font = .footnote()
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .snow

    let subviews: [UIView] = [titleLabel, displayDate]
    self.add(subviews)
    self.setUpView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  fileprivate func setUpView() {
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.displayDate.snp.bottom)
      make.leading.equalTo(Metric.leftPadding)
    }

    self.displayDate.snp.makeConstraints { make in
      if #available(iOS 11.0, *), iPhoneX() == true {
        make.top.equalTo(self.safeAreaLayoutGuide.snp.topMargin).offset(8)
      } else {
        make.top.equalTo(Metric.cellPadding)
      }
      make.leading.equalTo(Metric.leftPadding)
    }
  }

  // MARK: - Size

  override var intrinsicContentSize: CGSize {
    if iPhoneX() == true {
      return CGSize(width: self.width, height: 110)
    } else {
      return CGSize(width: self.width, height: 100)
    }
  }

  func iPhoneX() -> Bool {
    let screenRect: CGRect = UIScreen.main.bounds
    return max(screenRect.size.height, screenRect.size.width) == 812
  }

}
