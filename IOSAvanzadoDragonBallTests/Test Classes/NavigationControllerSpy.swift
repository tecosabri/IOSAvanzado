//
//  UINavigationControllerSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import UIKit

class NavigationControllerSpy: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
