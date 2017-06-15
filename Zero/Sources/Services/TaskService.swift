//
//  TaskService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxSwift

enum TaskEvent {
  case create(Task)
  case update(Task)
  case delete(id: String)
  case move(id: String, to: Int)
  case increaseValue(id: String)
}

protocol TaskServiceType {
  var event: PublishSubject<TaskEvent> { get }
  func fetchTask() -> Observable<[Task]>

  @discardableResult
  func saveTasks(_ tasks: [Task]) -> Observable<Void>

  func create(title: String, memo: String?) -> Observable<Task>
  func update(taskID: String, title: String, memo: String?) -> Observable<Task>
  func delete(taskID: String) -> Observable<Task>
  func move(taskID: String, to: Int) -> Observable<Task>
  func increaseValue(taskID: String) -> Observable<Task>
}

final class TaskService: BaseService, TaskServiceType {

  let event = PublishSubject<TaskEvent>()

  func fetchTask() -> Observable<[Task]> {
    if let savedTaskDictionaries = self.provider.userDefaultsService.value(forKey: .tasks) {
      let tasks = savedTaskDictionaries.flatMap(Task.init)
      return .just(tasks)
    }

    let defaultTasks: [Task] = [
      Task(title: "➕ Tap me"),
      Task(title: "👈 Swipe left")
    ]

    let defaultsTaskDictionaries = defaultTasks.map { $0.asDictionary() }
    self.provider.userDefaultsService.set(value: defaultsTaskDictionaries, forKey: .tasks)
    return .just(defaultTasks)
  }

  @discardableResult
  func saveTasks(_ tasks: [Task]) -> Observable<Void> {
    let dicts = tasks.map { $0.asDictionary() }
    self.provider.userDefaultsService.set(value: dicts, forKey: .tasks)
    return .just(Void())
  }

  func create(title: String, memo: String?) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let `self` = self else { return .empty() }
        let newTask = Task(title: title, memo: memo)
        return self.saveTasks(tasks + [newTask]).map { newTask }
    }
    .do(onNext: { task in
      self.event.onNext(.create(task))
    })
  }

  func update(taskID: String, title: String, memo: String?) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let `self` = self else { return .empty() }
        guard let index = tasks.index(where: { $0.id == taskID }) else { return .empty() }
        var tasks = tasks
        let newTask = tasks[index].with {
          $0.title = title
          $0.memo = memo
        }
        tasks[index] = newTask
        return self.saveTasks(tasks).map { newTask }
    }
      .do(onNext: { task in
        self.event.onNext(.update(task))
      })
  }

  func delete(taskID: String) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let `self` = self else { return .empty() }
        guard let index = tasks.index(where: { $0.id == taskID }) else { return .empty() }
        var tasks = tasks
        let deletedTasks = tasks.remove(at: index)
        return self.saveTasks(tasks).map { deletedTasks }
    }
      .do(onNext: { task in
        self.event.onNext(.delete(id: task.id))
      })
  }

  func move(taskID: String, to destinationIndex: Int) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let `self` = self else { return .empty() }
        guard let sourceIndex = tasks.index(where: { $0.id == taskID }) else { return .empty() }
        var tasks = tasks
        let task = tasks.remove(at: sourceIndex)
        tasks.insert(task, at: destinationIndex)
        return self.saveTasks(tasks).map { task }
      }
      .do(onNext: { task in
        self.event.onNext(.move(id: task.id, to: destinationIndex))
      })
  }

  func increaseValue(taskID: String) -> Observable<Task> {
    return self.fetchTask()
      .flatMap { [weak self] tasks -> Observable<Task> in
        guard let `self` = self else { return .empty() }
        guard let index = tasks.index(where: { $0.id == taskID }) else { return .empty() }
        var tasks = tasks
        let newValue = tasks[index].with {
          $0.value += 1
          return
        }
        tasks[index] = newValue
        return self.saveTasks(tasks).map { newValue }
    }
      .do(onNext: { task in
        self.event.onNext(.increaseValue(id: task.id))
      })
  }

}
