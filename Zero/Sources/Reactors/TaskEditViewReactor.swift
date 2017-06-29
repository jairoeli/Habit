//
//  TaskEditViewReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

enum TaskEditViewMode {
  case edit(Task)
}

final class TaskEditViewReactor: BaseReactor {

  enum Action {
    case updateTaskTitle(String)
    case updateNote(String)
    case cancel
    case submit
  }

  enum Mutation {
    case updateTaskTitle(String)
    case updateNote(String)
    case dismiss
  }

  struct State {
    var taskTitle: String
    var taskNote: String?
    var canSubmit: Bool
    var shouldConfirmCancel: Bool
    var isDismissed: Bool

    init(taskTitle: String, taskNote: String?, canSubmit: Bool) {
      self.taskTitle = taskTitle
      self.taskNote = taskNote
      self.canSubmit = canSubmit
      self.shouldConfirmCancel = false
      self.isDismissed = false
    }
  }

  // MARK: - Initializing

  let provider: ServiceProviderType
  let mode: TaskEditViewMode
  let initialState: State

  init(provider: ServiceProviderType, mode: TaskEditViewMode) {
    self.provider = provider
    self.mode = mode
    switch mode {
      case .edit(let task):
        self.initialState = State(taskTitle: task.title, taskNote: task.memo, canSubmit: true)
    }
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .updateTaskTitle(taskTitle): return .just(.updateTaskTitle(taskTitle))
    case let .updateNote(addNote): return .just(.updateNote(addNote))

    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      switch self.mode {
      case .edit(let task):
        return self.provider.taskService.update(taskID: task.id,
                                                title: self.currentState.taskTitle,
                                                memo: self.currentState.taskNote)
          .map { _ in .dismiss }
      }

    case .cancel: return .just(.dismiss)
    }
  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updateTaskTitle(taskTitle):
      state.taskTitle = taskTitle
      state.canSubmit = !taskTitle.isEmpty
      state.shouldConfirmCancel = taskTitle != self.initialState.taskTitle
      return state

    case let .updateNote(addNote):
      state.taskNote = addNote
      return state

    case .dismiss:
      state.isDismissed = true
      return state
    }
  }

}
