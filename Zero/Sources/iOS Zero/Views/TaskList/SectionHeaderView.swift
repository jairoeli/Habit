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
import SwiftDate

final class SectionHeaderView: UIView {

  struct Metric {
    static let cellPadding = 30.f
    static let leftPadding = 15.f
  }

  // MARK: - UI

  let titleLabel = UILabel() <== {
    $0.font = .bold(size: 34)
    $0.textColor = .charcoal

    let date = Date()
    let calendar = Calendar.current
    let current = calendar.component(.hour, from: date as Date)
    guard let hourInt = Int(current.description) else { return }

    if hourInt >= 12 && hourInt <= 16 {
      $0.text = "Good Afternoon!"
    } else if hourInt >= 0 && hourInt <= 12 {
      $0.text = "Good Morning!"
    } else if hourInt >= 16 && hourInt <= 20 {
      $0.text = "Good Evening!"
    } else if hourInt >= 20 && hourInt <= 24 {
      $0.text = "Good Night!"
    }
  }

  let displayDate = UILabel() <== {
    let date = DateInRegion()
    $0.text = date.string(dateStyle: .long, timeStyle: .none)
    $0.textColor = .charcoal
    $0.font = .bold(size: 18)
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white

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
      make.top.equalTo(Metric.cellPadding)
      make.left.equalTo(Metric.leftPadding)
    }

    self.displayDate.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(-2)
      make.left.equalTo(Metric.leftPadding)
    }
  }

  // MARK: - Size

  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.width, height: 110)
  }

}
