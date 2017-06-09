//
//  TransitionType.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation

enum TransitionType {

    case coverVertical
    case custom(PresentrAnimation)

    /// Associates a custom transition type to the class responsible for its animation.
    ///
    /// - Returns: PresentrAnimation subclass which conforms to 'UIViewControllerAnimatedTransitioning' to be used for the animation transition.
    func animation() -> PresentrAnimation {
        switch self {
        case .coverVertical:
            return CoverVerticalAnimation()
        case .custom(let animation):
            return animation
        }
    }

}
