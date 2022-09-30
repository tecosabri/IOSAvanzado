//
//  WelcomeViewControllerTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class WelcomeViewControllerTests: XCTestCase {
    
    var sut: WelcomeViewController!
    var mockToken =
    """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InByaXZhdGUifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiI3QUI4QUM0RC1BRDhGLTRBQ0UtQUE0NS0yMUU4NEFFOEJCRTciLCJlbWFpbCI6ImJlamxAa2VlcGNvZGluZy5lcyJ9.UQkianJsXDCQyUw-2QUPOL0aY2Vq-maWoHGYSJkzI9Q
    """
    
    override func setUp() {
        super.setUp()
        sut = WelcomeViewController(nibName: "WelcomeView", bundle: nil)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Lifecycle
    func testWelcomeViewController_whenViewLoaded_viewModelIsSet() {
        // given a welcomeViewController
        // when called viewDidLoad because of calling loadViewIfNeeded
        // then the viewModel is set
        XCTAssertNotNil(sut.viewModel, "The viewModel property of the welcomeViewController has to be set after initialization")
    }
    
    // MARK: - Navigation
    func testWelcomeViewController_whenNavigateToLoginScene_LoginViewControllerIsPushed() {
        // given
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: sut)
        
        // when
        sut.navigateToLoginScene()
        
        // then the current view controller is a login view controller
        XCTAssertTrue(navigationControllerSpy.pushedViewController is LoginViewController, "The viewController after calling navigateToLoginScene has to be a LoginViewController")
    }
    
    func testWelcomeViewController_whenNavigateToMapScene_MapViewControllerIsPushed() {
        // given
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: sut)
        
        // when
        sut.navigateToMap(withToken: mockToken)
        
        // then the current view controller is a login view controller
        XCTAssertTrue(navigationControllerSpy.pushedViewController is MapViewController, "The viewController after calling navigateToLoginScene has to be a MapViewController")
    }
}
