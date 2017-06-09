//
//  Presentr.swift
//  Zero
//
//  Created by Jairo Eli de Leon on 5/8/17.
//  Copyright © 2017 Jairo Eli de León. All rights reserved.
//

import Foundation
import UIKit

struct PresentrConstants {
    struct Values {
        static let defaultSideMargin: Float = 30.0
        static let defaultHeightPercentage: Float = 0.66
    }
}

enum DismissSwipeDirection {

    case `default`
    case bottom
    case top

}

// MARK: - PresentrDelegate

/**
 The 'PresentrDelegate' protocol defines methods that you use to respond to changes from the 'PresentrController'. All of the methods of this protocol are optional.
*/
@objc protocol PresentrDelegate {
    /**
     Asks the delegate if it should dismiss the presented controller on the tap of the outer chrome view.

     Use this method to validate requirments or finish tasks before the dismissal of the presented controller.

     After things are wrapped up and verified it may be good to dismiss the presented controller automatically so the user does't have to close it again.

     - parameter keyboardShowing: Whether or not the keyboard is currently being shown by the presented view.
     - returns: False if the dismissal should be prevented, otherwise, true if the dimissal should occur.
     */
    @objc optional func presentrShouldDismiss(keyboardShowing: Bool) -> Bool
}

/// Main Presentr class. This is the point of entry for using the framework.
class Presentr: NSObject {

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    var presentationType: PresentationType

    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    var transitionType: TransitionType?

    /// The type of transition animation to be used to dismiss the view controller. This is optional, if not provided transitionType or default value will be used.
    var dismissTransitionType: TransitionType?

    /// Shadow settings for presented controller.
    var dropShadow: PresentrShadow?

    /// Should the presented controller dismiss on background tap. Default is true.
    var dismissOnTap = true

    /// Should the presented controller dismiss on Swipe inside the presented view controller. Default is false.
    var dismissOnSwipe = false

    /// If dismissOnSwipe is true, the direction for the swipe. Default depends on presentation type.
    var dismissOnSwipeDirection: DismissSwipeDirection = .default

    /// Should the presented controller use animation when dismiss on background tap or swipe. Default is true.
    var dismissAnimated = true

    /// Color of the background. Default is Black.
    var backgroundColor = UIColor.black

    /// Opacity of the background. Default is 0.7.
    var backgroundOpacity: Float = 0.7

    /// Should the presented controller blur the background. Default is false.
    var blurBackground = false

    /// The type of blur to be applied to the background. Ignored if blurBackground is set to false. Default is Dark.
    var blurStyle: UIBlurEffectStyle = .dark

    /// A custom background view to be added on top of the regular background view.
    var customBackgroundView: UIView?

    /// How the presented view controller should respond to keyboard presentation.
    var keyboardTranslationType: KeyboardTranslationType = .none

    /// When a ViewController for context is set this handles what happens to a tap when it is outside the context. True will ignore tap and pass the tap to the background controller, false will handle the tap and dismiss the presented controller. Default is false.
    var shouldIgnoreTapOutsideContext = false

    /// Uses the ViewController's frame as context for the presentation. Imitates UIModalPresentation.currentContext
    weak var viewControllerForContext: UIViewController? {
        didSet {
            guard let viewController = viewControllerForContext, let view = viewController.view else {
                contextFrameForPresentation = nil
                return
            }
            let correctedOrigin = view.convert(view.frame.origin, to: nil) // Correct origin in relation to UIWindow
            contextFrameForPresentation = CGRect(x: correctedOrigin.x, y: correctedOrigin.y, width: view.bounds.width, height: view.bounds.height)
        }
    }

    fileprivate var contextFrameForPresentation: CGRect?

    // MARK: Init

    init(presentationType: PresentationType) {
        self.presentationType = presentationType
    }

    // MARK: Private Methods

    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.

     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    fileprivate func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .custom
        presentingVC.present(presentedVC, animated: animated, completion: completion)
    }

    fileprivate var transitionForPresent: TransitionType {
        return transitionType ?? presentationType.defaultTransitionType()
    }

    fileprivate var transitionForDismiss: TransitionType {
        return dismissTransitionType ?? transitionType ?? presentationType.defaultTransitionType()
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForPresent.animation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForDismiss.animation()
    }

    // MARK: - Private Helper's

    fileprivate func presentationController(_ presented: UIViewController, presenting: UIViewController?) -> PresentrController {
        return PresentrController(presentedViewController: presented,
                                    presentingViewController: presenting,
                                    presentationType: presentationType,
                                    dropShadow: dropShadow,
                                    dismissOnTap: dismissOnTap,
                                    dismissOnSwipe: dismissOnSwipe,
                                    dismissOnSwipeDirection: dismissOnSwipeDirection,
                                    backgroundColor: backgroundColor,
                                    backgroundOpacity: backgroundOpacity,
                                    blurBackground: blurBackground,
                                    blurStyle: blurStyle,
                                    customBackgroundView: customBackgroundView,
                                    keyboardTranslationType:  keyboardTranslationType,
                                    dismissAnimated: dismissAnimated,
                                    contextFrameForPresentation: contextFrameForPresentation,
                                    shouldIgnoreTapOutsideContext: shouldIgnoreTapOutsideContext)
    }

}

// MARK: - UIViewController extension to provide customPresentViewController(_:viewController:animated:completion:) method

extension UIViewController {

    /// Present a view controller with a custom presentation provided by the Presentr object.
    ///
    /// - Parameters:
    ///   - presentr: Presentr object used for custom presentation.
    ///   - viewController: The view controller to be presented.
    ///   - animated: Animation setting for the presentation.
    ///   - completion: Completion handler.
    func customPresentViewController(_ presentr: Presentr, viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewController,
                                       animated: animated,
                                       completion: completion)
    }

}
