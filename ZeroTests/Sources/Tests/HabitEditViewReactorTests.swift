//
//  TaskEditViewReactorTests.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import XCTest
@testable import Zero

import RxCocoa
import RxExpect
import RxOptional
import RxSwift
import RxTest

class HabitEditViewReactorTests: XCTestCase {

  func testIsDismissed() {
    RxExpect("it should dismiss on submit") { test in
      let provider = MockServiceProvider()
      let habit = Habit(title: "Test")
      let reactor = test.retain(HabitEditViewReactor(provider: provider, mode: .edit(habit)))

      // input
      test.input(reactor.action, [
        next(100, .updateHabitTitle("Test")),
        next(200, .submit),
        ])

      // assert
      test.assert(reactor.state.map { $0.canSubmit }.distinctUntilChanged())
        .filterNext()
        .equal([
          true, // initial
          ])
    }
  }
}

