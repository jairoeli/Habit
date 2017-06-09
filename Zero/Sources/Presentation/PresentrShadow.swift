//
//  PresentrShadow.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

/// Helper struct that represents the shadow properties
struct PresentrShadow {

    let shadowColor: UIColor?

    let shadowOpacity: Float?

    let shadowOffset: CGSize?

    let shadowRadius: CGFloat?

    init(shadowColor: UIColor?, shadowOpacity: Float?, shadowOffset: CGSize?, shadowRadius: CGFloat?) {
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }

}
