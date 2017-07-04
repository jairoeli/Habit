//
//  HabitEditViewReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/12/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

enum HabitEditViewMode {
  case edit(Habit)
}

final class HabitEditViewReactor: BaseReactor {

  enum Action {
    case updateHabitTitle(String)
    case updateNote(String)
    case cancel
    case submit
  }

  enum Mutation {
    case updateHabitTitle(String)
    case updateNote(String)
    case dismiss
  }

  struct State {
    var habitTitle: String
    var habitNote: String?
    var canSubmit: Bool
    var shouldConfirmCancel: Bool
    var isDismissed: Bool

    init(habitTitle: String, habitNote: String?, canSubmit: Bool) {
      self.habitTitle = habitTitle
      self.habitNote = habitNote
      self.canSubmit = canSubmit
      self.shouldConfirmCancel = false
      self.isDismissed = false
    }
  }

  // MARK: - Initializing

  let provider: ServiceProviderType
  let mode: HabitEditViewMode
  let initialState: State

  init(provider: ServiceProviderType, mode: HabitEditViewMode) {
    self.provider = provider
    self.mode = mode
    switch mode {
      case .edit(let habit):
        self.initialState = State(habitTitle: habit.title, habitNote: habit.memo, canSubmit: true)
    }
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .updateHabitTitle(habitTitle): return .just(.updateHabitTitle(habitTitle))
    case let .updateNote(addNote): return .just(.updateNote(addNote))

    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      switch self.mode {
      case .edit(let habit):
        return self.provider.habitService.update(habitID: habit.id,
                                                title: self.currentState.habitTitle,
                                                memo: self.currentState.habitNote)
          .map { _ in .dismiss }
      }

    case .cancel: return .just(.dismiss)
    }
  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .updateHabitTitle(habitTitle):
      state.habitTitle = habitTitle
      state.canSubmit = !habitTitle.isEmpty
      state.shouldConfirmCancel = habitTitle != self.initialState.habitTitle
      return state

    case let .updateNote(addNote):
      state.habitNote = addNote
      return state

    case .dismiss:
      state.isDismissed = true
      return state
    }
  }

}
