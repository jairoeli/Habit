//
//  UITableView+Rx.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 6/1/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UITableView {

  func itemSelected<S: SectionModelType>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
    let source = self.itemSelected.map { indexPath in
      dataSource[indexPath]
    }

    return ControlEvent(events: source)
  }

}
