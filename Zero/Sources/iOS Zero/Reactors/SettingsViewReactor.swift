//
//  SettingsViewReactor.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingsViewReactor: Reactor {
  typealias Action = NoAction

  struct State {
    var sections: [SettingsViewSection] = []

    init(sections: [SettingsViewSection]) {
      self.sections = sections
    }
  }

  let provider: ServiceProviderType
  let initialState: State

  init(provider: ServiceProviderType) {
    self.provider = provider

    let aboutSection = SettingsViewSection.about([
        .github(SettingItemCellReactor(text: "View on GitHub", detailText: nil)),
        .icons(SettingItemCellReactor(text: "Icons from", detailText: "nucleoapp.com"))
      ])

    let sections = [aboutSection]
    self.initialState = State(sections: sections)
  }

}
