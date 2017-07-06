//
//  SettingsViewSection.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxDataSources

enum SettingsViewSection {
  case about([SettingsViewSectionItem])
}

extension SettingsViewSection: SectionModelType {
  var items: [SettingsViewSectionItem] {
    switch self {
    case .about(let items): return items
    }
  }

  init(original: SettingsViewSection, items: [SettingsViewSectionItem]) {
    switch original {
    case .about: self = .about(items)
    }
  }
}

enum SettingsViewSectionItem {
  case github(SettingItemCellReactor)
  case icons(SettingItemCellReactor)
  case version(SettingItemCellReactor)
}
