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

final class TaskListViewReactor: Reactor {

  enum Action {
    case refresh
    case deleteTask(IndexPath)
  }

  enum Mutation {
    case setSections([TaskListSection])
    case insertSectionItem(IndexPath, TaskListSection.Item)
    case updateSectionItem(IndexPath, TaskListSection.Item)
    case deleteSectionItem(IndexPath)
  }

  struct State {
    var isEditing: Bool
    var sections: [TaskListSection]
  }

  let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType) {
    self.provider = provider
    self.initialState = State(isEditing: false, sections: [TaskListSection(model: Void(), items: [])])
  }

  // MARK: - Mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return self.provider.taskService.fetchTask()
        .map { tasks in
          let sectionItems = tasks.map(TaskCellReactor.init)
          let section = TaskListSection(model: Void(), items: sectionItems)
          return .setSections([section])
      }

    case let .deleteTask(indexPath):
      let task = self.currentState.sections[indexPath].currentState
      return self.provider.taskService.delete(taskID: task.id).flatMap { _ in Observable.empty() }
    }
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let taskEventMutation = self.provider.taskService.event
      .flatMap { [weak self] taskEvent -> Observable<Mutation> in
        self?.mutate(taskEvent: taskEvent) ?? .empty()
    }
    return Observable.of(mutation, taskEventMutation).merge()
  }

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

    case let .markAsDone(id):
      guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      var task = state.sections[indexPath].currentState
      task.isDone = true
      let reactor = TaskCellReactor(task: task)
      return .just(.updateSectionItem(indexPath, reactor))

    case let .markAsUnDone(id):
      guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
      var task = state.sections[indexPath].currentState
      task.isDone = false
      let reactor = TaskCellReactor(task: task)
      return .just(.updateSectionItem(indexPath, reactor))
    }

  }

  // MARK: - Reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state

    switch mutation {
    case let .setSections(sections):
      state.sections = sections
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

  // MARK: - Creating Task

  func reactorForCreatingTask() -> TaskEditViewReactor {
    return TaskEditViewReactor(provider: self.provider, mode: .new)
  }

  func reactorForEditingTask(_ taskCellReactor: TaskCellReactor) -> TaskEditViewReactor {
    let task = taskCellReactor.currentState
    return TaskEditViewReactor(provider: self.provider, mode: .edit(task))
  }

}
