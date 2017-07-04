//
//  HabitService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxSwift

enum HabitEvent {
  case create(Habit)
  case update(Habit)
  case delete(id: String)
  case move(id: String, to: Int)
  case increaseValue(id: String)
  case decreaseValue(id: String)
}

protocol HabitServiceType {
  var event: PublishSubject<HabitEvent> { get }
  func fetchHabit() -> Observable<[Habit]>

  @discardableResult
  func saveHabits(_ habits: [Habit]) -> Observable<Void>

  func create(title: String, memo: String?) -> Observable<Habit>
  func update(habitID: String, title: String, memo: String?) -> Observable<Habit>
  func delete(habitID: String) -> Observable<Habit>
  func move(habitID: String, to: Int) -> Observable<Habit>
  func increaseValue(habitID: String) -> Observable<Habit>
  func decreaseValue(habitID: String) -> Observable<Habit>
}

final class HabitService: BaseService, HabitServiceType {

  let event = PublishSubject<HabitEvent>()

  func fetchHabit() -> Observable<[Habit]> {
    if let savedHabitDictionaries = self.provider.userDefaultsService.value(forKey: .habits) {
      let habits = savedHabitDictionaries.flatMap(Habit.init)
      return .just(habits)
    }

    let defaultHabits: [Habit] = [
      Habit(title: "➕ Tap me"),
      Habit(title: "👈 Swipe left"),
      Habit(title: "👉 Swipe right")
    ]

    let defaultsHabitDictionaries = defaultHabits.map { $0.asDictionary() }
    self.provider.userDefaultsService.set(value: defaultsHabitDictionaries, forKey: .habits)
    return .just(defaultHabits)
  }

  @discardableResult
  func saveHabits(_ habits: [Habit]) -> Observable<Void> {
    let dicts = habits.map { $0.asDictionary() }
    self.provider.userDefaultsService.set(value: dicts, forKey: .habits)
    return .just(Void())
  }

  func create(title: String, memo: String?) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        let newHabit = Habit(title: title, memo: memo)
        return self.saveHabits(habits + [newHabit]).map { newHabit }
    }
    .do(onNext: { habit in
      self.event.onNext(.create(habit))
    })
  }

  func update(habitID: String, title: String, memo: String?) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        guard let index = habits.index(where: { $0.id == habitID }) else { return .empty() }
        var habits = habits
        let newHabit = habits[index].with {
          $0.title = title
          $0.memo = memo
        }
        habits[index] = newHabit
        return self.saveHabits(habits).map { newHabit }
    }
      .do(onNext: { habit in
        self.event.onNext(.update(habit))
      })
  }

  func delete(habitID: String) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        guard let index = habits.index(where: { $0.id == habitID }) else { return .empty() }
        var habits = habits
        let deletedHabits = habits.remove(at: index)
        return self.saveHabits(habits).map { deletedHabits }
    }
      .do(onNext: { habit in
        self.event.onNext(.delete(id: habit.id))
      })
  }

  func move(habitID: String, to destinationIndex: Int) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        guard let sourceIndex = habits.index(where: { $0.id == habitID }) else { return .empty() }
        var habits = habits
        let habit = habits.remove(at: sourceIndex)
        habits.insert(habit, at: destinationIndex)
        return self.saveHabits(habits).map { habit }
      }
      .do(onNext: { habit in
        self.event.onNext(.move(id: habit.id, to: destinationIndex))
      })
  }

  func increaseValue(habitID: String) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        guard let index = habits.index(where: { $0.id == habitID }) else { return .empty() }
        var habits = habits
        let newValue = habits[index].with {
          $0.value += 1
          return
        }
        habits[index] = newValue
        return self.saveHabits(habits).map { newValue }
    }
      .do(onNext: { habit in
        self.event.onNext(.increaseValue(id: habit.id))
      })
  }

  func decreaseValue(habitID: String) -> Observable<Habit> {
    return self.fetchHabit()
      .flatMap { [weak self] habits -> Observable<Habit> in
        guard let `self` = self else { return .empty() }
        guard let index = habits.index(where: { $0.id == habitID }) else { return .empty() }
        var habits = habits
        let newValue = habits[index].with {
          $0.value -= 1
          return
        }
        habits[index] = newValue
        return self.saveHabits(habits).map { newValue }
      }
      .do(onNext: { habit in
        self.event.onNext(.decreaseValue(id: habit.id))
      })
  }

}
