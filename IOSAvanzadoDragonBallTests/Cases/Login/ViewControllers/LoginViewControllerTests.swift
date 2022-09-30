//
//  LoginViewControllerTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 25/9/22.
//

import XCTest

import XCTest
@testable import IOSAvanzadoDragonBall

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    let user = "user"
    let password = "password"
    var mockToken =
    """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InByaXZhdGUifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiI3QUI4QUM0RC1BRDhGLTRBQ0UtQUE0NS0yMUU4NEFFOEJCRTciLCJlbWFpbCI6ImJlamxAa2VlcGNvZGluZy5lcyJ9.UQkianJsXDCQyUw-2QUPOL0aY2Vq-maWoHGYSJkzI9Q
    """
    
    override func setUp() {
        super.setUp()
        sut = LoginViewController(nibName: "LoginView", bundle: nil)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Model calling methods
    func testLoginViewController_whenViewWillAppear_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        sut.viewWillAppear(false)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onViewWillAppear)
    }
    
    func testLoginViewController_whenPressEnterButton_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let enterButton = sut.enterButton else { return }
        sut.onPressEnterButton(enterButton)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onPressEnterButton)
    }
    
    func testLoginViewController_whenPasswordTextFieldBeginEditing_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let passwordTextField = sut.passwordTextField else { return }
        sut.onPasswordTextFieldBeginEditing(passwordTextField)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onPasswordTextFieldBeginEditing)
    }
    
    func testLoginViewController_whenUserTextFieldReturnKey_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let usertTextField = sut.passwordTextField else { return }
        sut.onUserTextFieldReturnKey(usertTextField)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onUserTextFieldReturnKey)
    }
    
    func testLoginViewController_whenPasswordTextFieldEditChange_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let passwordTextField = sut.passwordTextField else { return }
        sut.onPasswordTextFieldEditChange(passwordTextField)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onPasswordTextFieldEditChange)
    }
    
    func testLoginViewController_whenPasswordTextFieldReturnKey_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let passwordTextField = sut.passwordTextField else { return }
        sut.onPasswordTextFieldReturnKey(passwordTextField)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onPasswordTextFieldReturnKey)
    }
    
    func testLoginViewController_whenUserTextFieldEndEdit_callsAnalogousMethodInViewModel() {
        // given
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        // when
        guard let usertTextField = sut.passwordTextField else { return }
        sut.onUserTextFieldEndEdit(usertTextField)
        // then the current view controller is a login view controller
        XCTAssertEqual(viewModelSpy.calledMethod, LoginViewModelCalledMethod.onUserTextFieldReturnKey)
    }
    
    // MARK: - Navigation
    func testLoginViewController_whenNavigateToMapViewController_mapViewControllerIsPushed() {
        // given
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: sut)
        // when
        sut.navigateToMap(withToken: mockToken)
        // then the current view controller is a login view controller
        XCTAssertTrue(navigationControllerSpy.pushedViewController is MapViewController, "The viewController after calling navigateToMap has to be a MapViewController")
    }
    
    // MARK: - Buttons
    func testLoginViewController_whenHideBackButton_backButtonIsHiden() {
        // given
        let navigationItem = sut.navigationItem
        // when
        sut.hideBackButton()
        // then
        XCTAssertTrue(navigationItem.hidesBackButton)
    }
    
    func testLoginViewController_whenSwitchAnimatingActivityIndicator_activityIndicatorStopsAnimating() {
        // given
        sut.activityIndicator.startAnimating()
        // when
        sut.switchActivityIndicator()
        // then
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func testLoginViewController_whenSwitchStoppedActivityIndicator_activityIndicatorStartsAnimating() {
        // given
        sut.activityIndicator.stopAnimating()
        // when
        sut.switchActivityIndicator()
        // then
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func testLoginViewController_whenEnabledNotEnabledEnterButton_enterButtonIsEnabled() {
        // given
        guard let enterButton = sut.enterButton else { return }
        enterButton.isEnabled = false
        // when
        sut.enableEnterButton()
        // then
        XCTAssertTrue(enterButton.isEnabled)
    }
    
    func testLoginViewController_whenDisableEnabledEnterButton_enterButtonIsEnabled() {
        // given
        guard let enterButton = sut.enterButton else { return }
        enterButton.isEnabled = true
        // when
        sut.disableEnterButton()
        // then
        XCTAssertFalse(enterButton.isEnabled)
    }
    
    func testLoginViewController_whenSwipePasswordContent_passwordContentIsSwippedOut() {
        // given
        guard let passwordTextField = sut.passwordTextField else { return }
        passwordTextField.text = "RandomText"
        // when
        sut.swipePasswordContent()
        // then
        XCTAssertEqual(passwordTextField.text, "")
    }
    
    func testLoginViewController_whenAutocompletePasswordTextField_passwordTextFieldIsCompleted() {
        // given
        guard let passwordTextField = sut.passwordTextField else { return }
        passwordTextField.text = ""
        // when
        sut.autocompletePasswordTextField(withPassword: "Password")
        // then
        XCTAssertEqual(passwordTextField.text, "Password")
    }
}
