//
//  ModelType.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//
import UIKit

protocol Air {}
extension NSObject: Air {}

protocol Identifiable {
  associatedtype Identifier: Equatable
  var id: Identifier { get }
}

protocol ModelType: Air {}

extension Collection where Self.Iterator.Element: Identifiable {

  func index(of element: Self.Iterator.Element) -> Self.Index? {
    return self.index { $0.id == element.id }
  }

}
