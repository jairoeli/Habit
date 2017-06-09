//
//  BackgroundView.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

class PassthroughBackgroundView: UIView {

    var passthroughViews: [UIView] = []

    var shouldPassthrough = true

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)

        if !shouldPassthrough {
            return view
        }

        if view == self {
            for passthroughView in passthroughViews {
                view = passthroughView.hitTest(convert(point, to: passthroughView), with: event)
                if view != nil {
                    break
                }
            }
        }

        return view
    }

}
