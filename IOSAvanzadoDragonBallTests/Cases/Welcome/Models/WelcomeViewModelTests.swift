//
//  WelcomeViewModelTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 23/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class WelcomeViewModelTests: XCTestCase {
    
    var sut: WelcomeViewModel!
    var welcomeViewControllerSpy: WelcomeViewControllerSpy!
    let account = "DragonBall"
    let password = "RandomPassword"
    let navigateExpectation = "NavigateToLogin"
    

    override func setUp() {
        super.setUp()
        welcomeViewControllerSpy = WelcomeViewControllerSpy()
        sut = WelcomeViewModel(viewDelegate: welcomeViewControllerSpy)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testWelcomeViewModel_whenAvailableToken_viewDelegateNavigateToMapIsCalled() {
        // given stored password for account
        try! KeychainManager.save(password: password, forAccount: account)
        // when
        sut.onViewLoad()
        let expectation = XCTestExpectation(description: navigateExpectation)
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            XCTAssertTrue(self.welcomeViewControllerSpy.callingState == .navigateToMap)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
        try! KeychainManager.deletePassword(forAccount: account)
    }
    
    func testWelcomeViewModel_whenNotAvailableToken_viewDelegateNavigateToLoginIsCalled() {
        // given not stored password (token) for account
        // when
        sut.onViewLoad()
        let expectation = XCTestExpectation(description: navigateExpectation)
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            XCTAssertTrue(self.welcomeViewControllerSpy.callingState == .navigateToLoginScene)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.5)
    }
    
    
}
