//
//  SwipeActionDescriptor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/18/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
import SwipeCellKit

enum ActionDescriptor {
  case edit, decrease, trash

  func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
    guard displayMode != .imageOnly else { return nil }

    switch self {
      case .edit: return "Edit"
      case .decrease: return "Decrease"
      case .trash: return "Trash"
    }
  }

  func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
    guard displayMode != .titleOnly else { return nil }

    let name: String
    switch self {
      case .edit: name = "edit"
      case .decrease: name = "minus"
      case .trash: name = "trash"
    }

    return UIImage(named: style == .backgroundColor ? name : "")
  }

  var color: UIColor {
    switch self {
      case .edit: return .charcoal
      case .decrease: return .charcoal
      case .trash: return .redGraphite
    }
  }
}

enum ButtonDisplayMode {
  case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
  case backgroundColor
}

// MARK: - Swipe Table View Delegate
extension HabitListViewController: SwipeTableViewCellDelegate {

  func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
    action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
    action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)

    switch buttonStyle {
      case .backgroundColor:
        action.backgroundColor = descriptor.color
        action.font = .regular(size: 13)
    }
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

    if orientation == .left {
      guard isSwipeRightEnabled else { return nil }

      let decreaseAction = SwipeAction(style: .default, title: "Decrease") { [weak self] _, indexPath in
        self?.reactor?.action.onNext(Reactor.Action.habitDecreaseValue(indexPath))
      }
      configure(action: decreaseAction, with: .decrease)

      return [decreaseAction]
    } else {
      let deleteAction = SwipeAction(style: .destructive, title: "Trash") { [weak self] _, indexPath in
        self?.reactor?.action.onNext(Reactor.Action.deleteHabit(indexPath))
      }
      configure(action: deleteAction, with: .trash)

      let editAction = SwipeAction(style: .default, title: "Edit") { [weak self] _, indexPath in
        guard let `self` = self else { return }
        let dataSource = self.dataSource[indexPath]

        guard let reactor = self.reactor?.reactorForEditingHabit(dataSource) else { return }
        let viewController = HabitEditViewController(reactor: reactor)
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true, completion: nil)
      }
      editAction.hidesWhenSelected = true
      configure(action: editAction, with: .edit)

      return [deleteAction, editAction]
    }
  }

  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
    var options = SwipeTableOptions()
    options.transitionStyle = .border

    switch buttonStyle {
    case .backgroundColor:
      options.buttonSpacing = 10
    }

    return options
  }
}
