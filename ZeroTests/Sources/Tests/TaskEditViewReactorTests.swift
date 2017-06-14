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

class TaskEditViewReactorTests: XCTestCase {

  func testCanSubmit() {
    RxExpect("it should adjust canSubmit when the editor mode is .new") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskEditViewReactor(provider: provider, mode: .new))

      // input
      test.input(reactor.action, [
        next(100, .updateTaskTitle("a")),
        next(200, .updateTaskTitle("")),
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

  func testShouldComfirmCancel() {
    RxExpect("it should confirm cancel when the editor mode is .new") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskEditViewReactor(provider: provider, mode: .new))

      // input
      test.input(reactor.action, [
        next(100, .updateTaskTitle("a")),
        next(200, .updateTaskTitle("")),
        ])

      // assert
      test.assert(reactor.state.map { $0.shouldConfirmCancel })
        .filterNext()
        .equal([
          false, // initial
          true,  // "a"
          false, // ""
          ])
    }
  }

  func testIsDismissed() {
    RxExpect("it should dismiss on cancel") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskEditViewReactor(provider: provider, mode: .new))

      // input
      test.input(reactor.action, [
        next(100, .cancel),
        ])

      // assert
      test.assert(reactor.state.map { $0.isDismissed }.distinctUntilChanged())
        .filterNext()
        .equal([
          false, // initial
          true,  // cancel
          ])
    }

    RxExpect("it should dismiss on submit") { test in
      let provider = MockServiceProvider()
      let reactor = test.retain(TaskEditViewReactor(provider: provider, mode: .new))

      // input
      test.input(reactor.action, [
        next(100, .updateTaskTitle("a")),
        next(200, .submit),
        ])

      // assert
      test.assert(reactor.state.map { $0.isDismissed }.distinctUntilChanged())
        .filterNext()
        .equal([
          false, // initial
          true,  // submit
          ])
    }
  }

}
