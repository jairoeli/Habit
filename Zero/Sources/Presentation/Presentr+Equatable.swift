//
//  Presentr+Equatable.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

extension PresentationType: Equatable { }
func == (lhs: PresentationType, rhs: PresentationType) -> Bool {
    switch (lhs, rhs) {
    case (let .custom(lhsWidth, lhsHeight, lhsCenter), let .custom(rhsWidth, rhsHeight, rhsCenter)):
        return lhsWidth == rhsWidth && lhsHeight == rhsHeight && lhsCenter == rhsCenter
    case (.popup, .popup):
        return true
    case (.dynamic, .dynamic):
        return true
    default:
        return false
    }
}

extension ModalSize: Equatable { }
func == (lhs: ModalSize, rhs: ModalSize) -> Bool {
    switch (lhs, rhs) {
    case (let .custom(lhsSize), let .custom(rhsSize)):
        return lhsSize == rhsSize
    case (.default, .default):
        return true
    case (.full, .full):
        return true
    default:
        return false
    }
}

extension ModalCenterPosition: Equatable { }
func == (lhs: ModalCenterPosition, rhs: ModalCenterPosition) -> Bool {
    switch (lhs, rhs) {
    case (let .custom(lhsCenterPoint), let .custom(rhsCenterPoint)):
        return lhsCenterPoint.x == rhsCenterPoint.x && lhsCenterPoint.y == rhsCenterPoint.y
    case (.center, .center):
        return true
    case (.topCenter, .topCenter):
        return true
    case (.bottomCenter, .bottomCenter):
        return true
    default:
        return false
    }
}
