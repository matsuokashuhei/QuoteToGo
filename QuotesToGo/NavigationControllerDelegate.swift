//
//  NavigationControllerDelegate.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC.restorationIdentifier == "Welcome" {
            return StartTransitionAnimator()
        } else {
            return nil
        }
    }

}
