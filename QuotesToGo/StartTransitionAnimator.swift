//
//  StartTransitionAnimator.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit

class StartTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    weak var transitionContext: UIViewControllerContextTransitioning?

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! WelcomeViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! AllQuotesViewController
        
        containerView?.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        let fromRibbon = fromViewController.ribbon
        let toRibbon = toViewController.ribbon
        toRibbon.transform = CGAffineTransformMakeTranslation(0, -60)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            fromRibbon.transform = CGAffineTransformMakeTranslation(0, -300)
            UIView.animateWithDuration(0.2, delay: 0.1, options: .CurveEaseInOut, animations: { () -> Void in
                toViewController.view.alpha = 1
                }, completion: { (success) -> Void in
                    UIView.animateWithDuration(0.2, delay: 0.1, options: .CurveEaseInOut, animations: { () -> Void in
                        toRibbon.transform = CGAffineTransformIdentity
                        }, completion: { (success) -> Void in
                            transitionContext.completeTransition(true)
                    })
            })
            }, completion: nil)
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
    }

}
