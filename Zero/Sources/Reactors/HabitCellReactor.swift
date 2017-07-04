//
//  HabitCellReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class HabitCellReactor: Reactor {
  typealias Action = NoAction

  let initialState: Habit

  init(habit: Habit) {
    self.initialState = habit
  }
}
