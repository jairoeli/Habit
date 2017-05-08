//
//  MutateOperator.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

infix operator <==

@discardableResult
func <== <T>(x: T, f: (T) -> Void) -> T {
  f(x)
  return x
}

protocol Dao {}
extension NSObject: Dao {}

extension Dao where Self: Any {
  func with(_ block: (inout Self) -> Void) -> Self {
    var copy = self
    block(&copy)
    return copy
  }
}
