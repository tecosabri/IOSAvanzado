//
//  WelcomeViewControllerSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import UIKit
@testable import IOSAvanzadoDragonBall

enum WelcomeViewControllerCalling {
    case navigateToLoginScene, navigateToMap
}

class WelcomeViewControllerSpy: WelcomeViewControllerProtocol {
    
    var callingState: WelcomeViewControllerCalling? = nil

    func navigateToLoginScene() {
        callingState = .navigateToLoginScene
    }
    
    func navigateToMap(withToken token: String) {
        callingState = .navigateToMap
    }
    
    func fadeOutBackgroundImage() {} // Only added to conform to protocol
}
