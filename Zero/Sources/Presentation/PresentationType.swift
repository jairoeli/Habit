//
//  PresentationType.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/9/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

/// Basic Presentr type. Its job is to describe the 'type' of presentation. The type describes the size and position of the presented view controller.
///
/// - popup: This is a average/default size 'popup' modal.
/// - fullScreen: This takes up the entire screen.
/// - dynamic: Uses autolayout to calculate width & height. Have to provide center position.
/// - custom: User provided custom width, height & center position.
enum PresentationType {

    case popup
    case fullScreen
    case dynamic(center: ModalCenterPosition)
    case custom(width: ModalSize, height: ModalSize, center: ModalCenterPosition)

    /// Describes the sizing for each Presentr type. It is meant to be non device/width specific, except for the .custom case.
    ///
    /// - Returns: A tuple containing two 'ModalSize' enums, describing its width and height.
    func size() -> (width: ModalSize, height: ModalSize)? {
        switch self {
        case .popup:
            return (.default, .default)
        case .fullScreen:
            return (.full, .full)
        case .custom(let width, let height, _):
            return (width, height)
        case .dynamic:
            return nil
        }
    }

    /// Describes the position for each Presentr type. It is meant to be non device/width specific, except for the .custom case.
    ///
    /// - Returns: Returns a 'ModalCenterPosition' enum describing the center point for the presented modal.
    func position() -> ModalCenterPosition {
        switch self {
        case .popup:
            return .center
        case .fullScreen:
            return .center
        case .custom(_, _, let center):
            return center
        case .dynamic(let center):
            return center
        }
    }

    /// Associates each Presentr type with a default transition type, in case one is not provided to the Presentr object.
    ///
    /// - Returns: Return a 'TransitionType' which describes a transition animation.
    func defaultTransitionType() -> TransitionType {
        switch self {
        default:
            return .coverVertical
        }
    }

    /// Default round corners setting.
    var shouldRoundCorners: Bool {
        switch self {
        case .popup:
            return true
        default:
            return false
        }
    }

}
