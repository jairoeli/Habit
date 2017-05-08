//
//  UICollectionView+Rx.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UICollectionView {

  func itemSelected<S: SectionModelType>(dataSource: CollectionViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
    let source = self.itemSelected.map { indexPath in
      dataSource[indexPath]
    }
    return ControlEvent(events: source)
  }

}
