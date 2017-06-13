//
//  SettingItemCellReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingItemCellReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var text: String?
    var detailText: String?
  }

  let initialState: State

  init(text: String?, detailText: String?) {
    self.initialState = State(text: text, detailText: detailText)
  }
}
