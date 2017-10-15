//
//  TaskListViewReactorTests.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import XCTest
@testable import Zero

import RxCocoa
import RxExpect
import RxSwift
import RxTest

class TaskListViewReactorTests: XCTestCase {

  func testFetchHabits() {
    RxExpect("it should fetch saved habits") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(HabitListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [next(100, .refresh)])

      // assertion
      let habitCount = reactor.state.map { $0.sections.first!.items.count }
      test.assert(habitCount)
        .since(100)
        .filterNext()
        .equal([3])
    }
  }

  func testHabitIncreaseValue() {
    RxExpect("Tap cell to increase value") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(HabitListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [
        next(100, .refresh), // prepare seed data
        next(200, .habitIncreaseValue(IndexPath(item: 0, section: 0))),
        next(300, .habitIncreaseValue(IndexPath(item: 0, section: 0))),
        next(400, .habitIncreaseValue(IndexPath(item: 2, section: 0))),
        ])

      // assert
      let isIncrement = reactor.state.map { state in
        return state.sections[0].items.map { cellReactor in
          return cellReactor.currentState.value
        }
      }
      test.assert(isIncrement)
        .since(100)
        .filterNext()
        .equal([
          [0, 0, 0],
          [1, 0, 0],
          [2, 0, 0],
          [2, 0, 1],
          ])
    }
  }

  func testDeleteHabit() {
    RxExpect("it should delete the habit") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(HabitListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [
        next(100, .refresh), // prepare seed data
        next(200, .deleteHabit(IndexPath(item: 0, section: 0))),
        ])

      // assert
      let itemCount = reactor.state.map { $0.sections[0].items.count }
      test.assert(itemCount)
        .since(100)
        .filterNext()
        .equal([
          3, // initial
          2, // after delete
          ])
    }
  }

  func testCanSubmit() {
    RxExpect("it should adjust canSubmit when typing a new habit") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(HabitListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [
        next(100, .updateHabitTitle("a")),
        next(200, .updateHabitTitle("")),
        ])

      // assert
      test.assert(reactor.state.map { $0.canSubmit })
        .filterNext()
        .equal([
          false, // initial
          true,  // "a"
          false, // ""
          ])
    }

  }

}
