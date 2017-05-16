//
//  HabitCellReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/16/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class HabitCellReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var text: String?
  }

  let initialState: State

  init(text: String?) {
    self.initialState = State(text: text)
    _ = self.state
  }
}
