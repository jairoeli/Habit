//
//  BaseReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/20/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxSwift

protocol BaseReactor: Reactor {}

extension BaseReactor {

  func transform(action: Observable<Action>) -> Observable<Action> {
    return action.debug("action")
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation.debug("mutation")
  }

  func transform(state: Observable<State>) -> Observable<State> {
    return state.debug("state")
  }

}
