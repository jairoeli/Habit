//
//  HabitListViewReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias HabitListSection = SectionModel<Void, HabitCellReactor>

final class HabitListViewReactor: BaseReactor {

  enum Action {
    case updateHabitTitle(String)
    case submit
    case refresh
    case toggleEditing
    case moveHabit(IndexPath, IndexPath)
    case deleteHabit(IndexPath)
    case habitIncreaseValue(IndexPath)
    case habitDecreaseValue(IndexPath)
  }

  enum Mutation {
    case updateHabitTitle(String)
    case setSections([HabitListSection])
    case insertSectionItem(IndexPath, HabitListSection.Item)
    case updateSectionItem(IndexPath, HabitListSection.Item)
    case deleteSectionItem(IndexPath)
    case toggleEditing
    case moveSectionItem(IndexPath, IndexPath)
  }

  struct State {
    var sections: [HabitListSection]
    var isMoving: Bool
    var habitTitle: String
    var canSubmit: Bool

    init(isEditing: Bool, sections: [HabitListSection], habitTitle: String, canSubmit: Bool) {
      self.sections = sections
      self.habitTitle = habitTitle
      self.canSubmit = canSubmit
      self.isMoving = isEditing
    }
  }

  let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(isEditing: false, sections: [HabitListSection(model: Void(), items: [])], habitTitle: "", canSubmit: false)
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .updateHabitTitle(habitTitle): return .just(.updateHabitTitle(habitTitle))

    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      return self.provider.habitService.create(title: self.currentState.habitTitle, memo: nil).flatMap { _ in Observable.empty() }

    case .refresh:
      return self.provider.habitService.fetchHabit()
        .map { habits in
          let sectionItems = habits.map(HabitCellReactor.init)
          let section = HabitListSection(model: Void(), items: sectionItems)
          return .setSections([section])
      }

    case .toggleEditing: return .just(.toggleEditing)

    case let .moveHabit(sourceIndexPath, destinationIndexPath):
      let habit = self.currentState.sections[sourceIndexPath].currentState
      return self.provider.habitService.move(habitID: habit.id, to: destinationIndexPath.item)
        .flatMap { _ in Observable.empty() }

    case let .deleteHabit(indexPath):
      let habit = self.currentState.sections[indexPath].currentState
      return self.provider.habitService.delete(habitID: habit.id).flatMap { _ in Observable.empty() }

    case let .habitIncreaseValue(indexPath):
      let habit = self.currentState.sections[indexPath].currentState
      return self.provider.habitService.increaseValue(habitID: habit.id).flatMap { _ in Observable.empty() }

    case let .habitDecreaseValue(indexPath):
      let habit = self.currentState.sections[indexPath].currentState
      return self.provider.habitService.decreaseValue(habitID: habit.id).flatMap { _ in Observable.empty() }
    }

  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let habitEventMutation = self.provider.habitService.event
      .flatMap { [weak self] habitEvent -> Observable<Mutation> in
        self?.mutate(habitEvent: habitEvent) ?? .empty()
    }
    return Observable.of(mutation, habitEventMutation).merge()
  }

  // swiftlint:disable cyclomatic_complexity
  private func mutate(habitEvent: HabitEvent) -> Observable<Mutation> {
    let state = self.currentState

    switch habitEvent {
    case let .create(habit):
      let indexPath = IndexPath(item: 0, section: 0)
      let reactor = HabitCellReactor(habit: habit)
      return .just(.insertSectionItem(indexPath, reactor))

    case let .update(habit):
      guard let indexPath = self.indexPath(forHabitID: habit.id, from: state) else { return .empty() }
      let reactor = HabitCellReactor(habit: habit)
      return .just(.updateSectionItem(indexPath, reactor))

    case let .delete(id):
      guard let indexPath = self.indexPath(forHabitID: id, from: state) else { return .empty() }
      return .just(.deleteSectionItem(indexPath))

    case let .move(id, index):
      guard let sourceIndexPath = self.indexPath(forHabitID: id, from: state) else { return .empty() }
      let destinationIndexPath = IndexPath(item: index, section: 0)
      return .just(.moveSectionItem(sourceIndexPath, destinationIndexPath))

    case let .increaseValue(id):
      guard let indexPath = self.indexPath(forHabitID: id, from: state) else { return .empty() }
      var habit = state.sections[indexPath].currentState
      habit.value += 1
      let reactor = HabitCellReactor(habit: habit)
      return .just(.updateSectionItem(indexPath, reactor))

    case let .decreaseValue(id):
      guard let indexPath = self.indexPath(forHabitID: id, from: state) else { return .empty() }
      var habit = state.sections[indexPath].currentState
      habit.value -= 1
      let reactor = HabitCellReactor(habit: habit)
      return .just(.updateSectionItem(indexPath, reactor))
    }

  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state

    switch mutation {
    case let .updateHabitTitle(habitTitle):
      state.habitTitle = habitTitle
      state.canSubmit = !habitTitle.isEmpty
      return state

    case let .setSections(sections):
      state.sections = sections
      return state

    case .toggleEditing:
      state.isMoving = !state.isMoving
      return state

    case let .insertSectionItem(indexPath, sectionItem):
      state.sections.insert(sectionItem, at: indexPath)
      return state

    case let .updateSectionItem(indexPath, sectionItem):
      state.sections[indexPath] = sectionItem
      return state

    case let .deleteSectionItem(indexPath):
      state.sections.remove(at: indexPath)
      return state

    case let .moveSectionItem(sourceIndexPath, destinationIndexPath):
      let sectionItem = state.sections.remove(at: sourceIndexPath)
      state.sections.insert(sectionItem, at: destinationIndexPath)
      return state
    }

  }

  // MARK: - IndexPath

  private func indexPath(forHabitID habitID: String, from state: State) -> IndexPath? {
    let section = 0
    let item = state.sections[section].items.index { reactor in reactor.currentState.id == habitID }

    if let item = item {
      return IndexPath(item: item, section: section)
    } else {
      return nil
    }
  }

  // MARK: - Editing Habit

  func reactorForEditingHabit(_ habitCellReactor: HabitCellReactor) -> HabitEditViewReactor {
    let habit = habitCellReactor.currentState
    return HabitEditViewReactor(provider: self.provider, mode: .edit(habit))
  }

  // MARK: - Present Settings

  func settingsViewReactor() -> SettingsViewReactor {
    return SettingsViewReactor(provider: provider)
  }

}
