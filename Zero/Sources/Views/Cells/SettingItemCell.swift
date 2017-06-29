//
//  SettingItemCell.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

import ReactorKit

final class SettingItemCell: BaseTableViewCell, View {

  // MARK: Initializing
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.accessoryType = .disclosureIndicator
  }

  // MARK: Binding
  func bind(reactor: SettingItemCellReactor) {
    reactor.state
      .subscribe(onNext: { [weak self] state in
        self?.textLabel?.text = state.text
        self?.detailTextLabel?.text = state.detailText
      })
      .disposed(by: self.disposeBag)
  }

}
