//
//  Animation.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/10/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import UIKit

func animate(_ duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil, animations: @escaping () -> Void) {

  UIView.animate(withDuration: duration,
                 delay: 0.7,
                 usingSpringWithDamping: 0.7,
                 initialSpringVelocity: 3.0,
                 options: .curveEaseOut,
                 animations: animations,
                 completion: completion)
}
