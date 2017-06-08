//
//  MockAlertService.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit
@testable import Zero

import RxSwift

final class MockAlertService: BaseService, AlertServiceType, Dao {

  var selectAction: AlertActionType?

  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertControllerStyle,
    actions: [Action]
    ) -> Observable<Action> {
    guard let selectAction = self.selectAction as? Action else { return .empty() }
    return .just(selectAction)
  }
  
}
