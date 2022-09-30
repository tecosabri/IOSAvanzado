//
//  UINavigationControllerSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import UIKit

class NavigationControllerSpy: UINavigationController {
    
    var pushedViewController: UIViewController?
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
