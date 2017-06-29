//
//  TaskListViewReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

typealias TaskListSection = SectionModel<Void, TaskCellReactor>

final class TaskListViewReactor: BaseReactor {

  enum Action {
    case updateTaskTitle(String)
    case submit
    case refresh
    case toggleEditing
    case moveTask(IndexPath, IndexPath)
    case deleteTask(IndexPath)
    case taskIncreaseValue(IndexPath)
    case taskDecreaseValue(IndexPath)
  }

  enum Mutation {
    case updateTaskTitle(String)
    case setSections([TaskListSection])
    case insertSectionItem(IndexPath, TaskListSection.Item)
    case updateSectionItem(IndexPath, TaskListSection.Item)
    case deleteSectionItem(IndexPath)
    case toggleEditing
    case moveSectionItem(IndexPath, IndexPath)
  }

  struct State {
    var sections: [TaskListSection]
    var isMoving: Bool
    var taskTitle: String
    var canSubmit: Bool

    init(isEditing: Bool, sections: [TaskListSection], taskTitle: String, canSubmit: Bool) {
      self.sections = sections
      self.taskTitle = taskTitle
      self.canSubmit = canSubmit
      self.isMoving = isEditing
    }
  }

  let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(isEditing: false, sections: [TaskListSection(model: Void(), items: [])], taskTitle: "", canSubmit: false)
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .updateTaskTitle(taskTitle): return .just(.updateTaskTitle(taskTitle))

    case .submit:
      guard self.currentState.canSubmit else { return .empty() }
      return self.provider.taskService.create(title: self.currentState.taskTitle, memo: nil).flatMap { _ in Observable.empty() }

    case .refresh:
      return self.provider.taskService.fetchTask()
        .map { tasks in
          let sectionItems = tasks.map(TaskCellReactor.init)
          let section = TaskListSection(model: Void(), items: sectionItems)
          return .setSections([section])
      }

    case .toggleEditing: return .just(.toggleEditing)

    case let .moveTask(sourceIndexPath, destinationIndexPath):
      let task = self.currentState.sections[sourceIndexPath].currentState
      return self.provider.taskService.move(taskID: task.id, to: destinationIndexPath.item)
        .flatMap { _ in Observable.empty() }

    case let .deleteTask(indexPath):
      let task = self.currentState.sections[indexPath].currentState
      return self.provider.taskService.delete(taskID: task.id).flatMap { _ in Observable.empty() }

    case let .taskIncreaseValue(indexPath):
      let task = self.currentState.sections[indexPath].currentState
      return self.provider.taskService.increaseValue(taskID: task.id).flatMap { _ in Observable.empty() }

    case let .taskDecreaseValue(indexPath):
      let task = self.currentState.sections[indexPath].currentState
      return self.provider.taskService.decreaseValue(taskID: task.id).flatMap { _ in Observable.empty() }
    }

  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let taskEventMutation = self.provider.taskService.event
      .flatMap { [weak self] taskEvent -> Observable<Mutation> in
        self?.mutate(taskEvent: taskEvent) ?? .empty()
    }
    return Observable.of(mutation, taskEventMutation).merge()
  }

  // swiftlint:disable cyclomatic_complexity
  private func mutate(taskEvent: TaskEvent) -> Observable<Mutation> {
    let state = self.currentState

    switch taskEvent {
    case let .create(task):
      let indexPath = IndexPath(item: 0, section: 0)
      let reactor = TaskCellReactor(task: task)
      return .just(.insertSectionItem(indexPath, reactor))

    case let .update(task):
      guard let indexPath = self.indexPath(forTaskID: task.id, from: state) else { return .empty() }
      let reactor = TaskCellReactor(task: task)
      return .just(.updateSectionItem(indexPath, reactor))

    case let .delete(id):
      guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      return .just(.deleteSectionItem(indexPath))

    case let .move(id, index):
      guard let sourceIndexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      let destinationIndexPath = IndexPath(item: index, section: 0)
      return .just(.moveSectionItem(sourceIndexPath, destinationIndexPath))

    case let .increaseValue(id):
      guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      var task = state.sections[indexPath].currentState
      task.value += 1
      let reactor = TaskCellReactor(task: task)
      return .just(.updateSectionItem(indexPath, reactor))

    case let .decreaseValue(id):
      guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      var task = state.sections[indexPath].currentState
      task.value -= 1
      let reactor = TaskCellReactor(task: task)
      return .just(.updateSectionItem(indexPath, reactor))
    }

  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state

    switch mutation {
    case let .updateTaskTitle(taskTitle):
      state.taskTitle = taskTitle
      state.canSubmit = !taskTitle.isEmpty
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

  private func indexPath(forTaskID taskID: String, from state: State) -> IndexPath? {
    let section = 0
    let item = state.sections[section].items.index { reactor in reactor.currentState.id == taskID }

    if let item = item {
      return IndexPath(item: item, section: section)
    } else {
      return nil
    }
  }

  // MARK: - Editing Task

  func reactorForEditingTask(_ taskCellReactor: TaskCellReactor) -> TaskEditViewReactor {
    let task = taskCellReactor.currentState
    return TaskEditViewReactor(provider: self.provider, mode: .edit(task))
  }

  // MARK: - Present Settings

  func settingsViewReactor() -> SettingsViewReactor {
    return SettingsViewReactor(provider: provider)
  }

}
