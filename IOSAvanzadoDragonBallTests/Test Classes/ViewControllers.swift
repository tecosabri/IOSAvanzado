//
//  ViewControllers.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 23/9/22.
//

import UIKit

@testable import IOSAvanzadoDragonBall

func loadRootViewController() -> UINavigationController {
    let scenes = UIApplication.shared.connectedScenes
    let windowScenes = scenes.first as? UIWindowScene
    let rootViewController = windowScenes?.keyWindow?.rootViewController
    return rootViewController as! UINavigationController
}
