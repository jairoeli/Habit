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

  func testFetchTasks() {
    RxExpect("it should fetch saved tasks") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [next(100, .refresh)])

      // assertion
      let taskCount = reactor.state.map { $0.sections.first!.items.count }
      test.assert(taskCount)
        .since(100)
        .filterNext()
        .equal([3])
    }
  }

  func testToggleTaskDone() {
    RxExpect("it should toggle isDone of task") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [
        next(100, .refresh), // prepare seed data
        next(200, .taskDone(IndexPath(item: 0, section: 0))),
        next(300, .taskDone(IndexPath(item: 0, section: 0))),
        next(400, .taskDone(IndexPath(item: 2, section: 0))),
        ])

      // assert
      let isDones = reactor.state.map { state in
        return state.sections[0].items.map { cellReactor in
          return cellReactor.currentState.isDone
        }
      }
      test.assert(isDones)
        .since(100)
        .filterNext()
        .equal([
          [false, false, false],
          [true,  false, false],
          [false, false, false],
          [false, false, true ],
          ])
    }
  }

  func testDeleteTask() {
    RxExpect("it should delete the task") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskListViewReactor(provider: provider))

      // input
      test.input(reactor.action, [
        next(100, .refresh), // prepare seed data
        next(200, .deleteTask(IndexPath(item: 0, section: 0))),
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

}
