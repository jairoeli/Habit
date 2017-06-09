//
//  ModalSize.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

/**
 Descibes a presented modal's size dimension (width or height). It is meant to be non-specific, but the exact position can be calculated by calling the 'calculate' methods, passing in the 'parentSize' which only the Presentation Controller should be aware of.

 - Default:     Default size. Will use Presentr's default margins to calculate size of presented controller. This is the size the .Popup presentation type uses.
 - Full:        Full screen.
 - Custom:      Custom fixed size.
 */
enum ModalSize {

    case `default`
    case full
    case custom(size: Float)

    /**
     Calculates the exact width value for the presented view controller.

     - parameter parentSize: The presenting view controller's size. Provided by the presentation controller.

     - returns: Exact float width value.
     */
    func calculateWidth(_ parentSize: CGSize) -> Float {
        switch self {
        case .default:
            return floorf(Float(parentSize.width) - (PresentrConstants.Values.defaultSideMargin * 2.0))
        case .full:
            return Float(parentSize.width)
        case .custom(let size):
            return size
        }
    }

    /**
     Calculates the exact height value for the presented view controller.

     - parameter parentSize: The presenting view controller's size. Provided by the presentation controller.

     - returns: Exact float height value.
     */
    func calculateHeight(_ parentSize: CGSize) -> Float {
        switch self {
        case .default:
            return floorf(Float(parentSize.height) * PresentrConstants.Values.defaultHeightPercentage)
        case .full:
            return Float(parentSize.height)
        case .custom(let size):
            return size
        }
    }

}
