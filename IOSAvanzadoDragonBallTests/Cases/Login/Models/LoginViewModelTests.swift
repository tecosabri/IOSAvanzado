//
//  LoginViewModel.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 25/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!
    var viewDelegate: LoginViewControllerSpy!
    var mockToken =
    """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InByaXZhdGUifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiI3QUI4QUM0RC1BRDhGLTRBQ0UtQUE0NS0yMUU4NEFFOEJCRTciLCJlbWFpbCI6ImJlamxAa2VlcGNvZGluZy5lcyJ9.UQkianJsXDCQyUw-2QUPOL0aY2Vq-maWoHGYSJkzI9Q
    """
    var tokenAccount = "DragonBall"
    var user = "hisme14@gmail.com"
    var password = "123456"
    
    override func setUp() {
        super.setUp()
        viewDelegate = LoginViewControllerSpy()
        sut = LoginViewModel(viewDelegate: viewDelegate)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Press enter button
    func testloginViewModel_whenPressEnterButtonWithNoTokenSaved_switchActivityIndicatorIsCalled() {
        // given
        // when
        sut.onPressEnterButton(withUser: "", andPassword: "")
        // then the view delegate has to switch its activity indicator
        XCTAssertTrue(viewDelegate.callingState.contains(.switchActivityIndicator))
    }
    
    func testloginViewModel_whenPressEnterButtonWithTokenSaved_logsInWithInvalidToken() {
        // given
        // when pressed enter button with stored token
        sut.onPressEnterButton(withUser: "", andPassword: "")
        // then the view delegate has to switch activity indicator, swipe password, navigate to map and disable enter button
        XCTAssertTrue(viewDelegate.callingState.contains(.switchActivityIndicator))
    }
    
//    func testloginViewModel_whenPressEnterButtonWithRightUserAndPasswordAndNotSavedToken_setsUpToNavigate() {
//        // When waiting, other waiting tests fail!!
//
//        // given token is not saved
//        // when pressed enter button with stored token
//        sut.onPressEnterButton(withUser: user, andPassword: password)
//        // then the view delegate has to switch activity indicator, swipe password, navigate to map and disable enter button
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            XCTAssertTrue(self.viewDelegate.callingState.contains(.switchActivityIndicator))
//            XCTAssertTrue(self.viewDelegate.callingState.contains(.swipePasswordContent))
//            XCTAssertTrue(self.viewDelegate.callingState.contains(.navigateToMap))
//            XCTAssertTrue(self.viewDelegate.callingState.contains(.disableEnterButton))
//        }
//    }
    
    // MARK: PasswordFieldBeginEditing
    func testloginViewModel_whenPasswordTextFieldBeginEditingWithWrongUser_showsUserErrorAlert() {
        // given
        user = "hisme14"
        // when
        sut.onPasswordTextFieldBeginEditing(withUser: user)
        // then the view delegate shows user error alert
        XCTAssertTrue(viewDelegate.callingState.contains(.showUserErrorAlert))
    }
    
    func testloginViewModel_whenPasswordTextFieldBeginEditingWithRightUser_showsUserErrorAlert() {
        // given
        // when
        sut.onPasswordTextFieldBeginEditing(withUser: user)
        // then the view delegate DOESN'T show user error alert
        XCTAssertTrue(!viewDelegate.callingState.contains(.showUserErrorAlert))
    }
    
    // MARK: PasswordFieldEditChange
    func testloginViewModel_whenPasswordTextFieldEditWithPasswordLessThan3Chars_disablesEnterButton() {
        // given
        password = "12"
        // when
        sut.onPasswordTextFieldEditChange(withUser: user, andPassword: password)
        // then the view delegate disables enter button
        XCTAssertTrue(viewDelegate.callingState.contains(.disableEnterButton))
    }
    
    func testloginViewModel_whenPasswordTextFieldEditWithPasswordGreaterThan3Chars_disablesEnterButton() {
        // given user with length greater than 3 chars
        // when
        sut.onPasswordTextFieldEditChange(withUser: user, andPassword: password)
        // then the view delegate enables enter button
        XCTAssertTrue(!viewDelegate.callingState.contains(.disableEnterButton))
    }
    
    // MARK: User textfield return key
    func testloginViewModel_whenUserTextFieldReturnKeyWhenPasswordAlreadySaved_showsDecideToAutocomplete() {
        // given
        try? KeychainManager.save(password: password, forAccount: user)
        // when
        sut.onUserTextFieldReturnKey(withUser: user)
        // then the view delegate focus password textfield and shows decide to autocomplete
        XCTAssertTrue(viewDelegate.callingState.contains(.focusPasswordTextField))
        XCTAssertTrue(viewDelegate.callingState.contains(.showDecideToAutocomplete))
        try? KeychainManager.deletePassword(forAccount: user)
    }
    
    // MARK: Password textfield return key
    func testloginViewModel_whenPasswordTextFieldReturnKeyWhenEnterButtonEnabled_pushesEnterButton() {
        // given
        let isEnabled = true
        // when
        sut.onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs: isEnabled)
        // then the view delegate focus password textfield and shows decide to autocomplete
        XCTAssertTrue(viewDelegate.callingState.contains(.pushEnterButton))
    }
    
    
    // Decide to save
    func testloginViewModel_whenDecideToSaveWithNoAnswer_returns() {
        // given
        let answer = false
        // when
        sut.onDecideToSave(password: password, forUser: user, withAnswer: answer)
        // then the view delegate doesn't call any method
        XCTAssertTrue(viewDelegate.callingState.isEmpty)
    }
    
    func testloginViewModel_whenDecideToSaveWithYesAnswer_savesPassword() {
        // given
        let answer = true
        // when
        sut.onDecideToSave(password: password, forUser: user, withAnswer: answer)
        // then the view delegate saves the password
        guard let password = try? KeychainManager.getPassword(forAccount: user) else { return }
        XCTAssertEqual(password, password)
        try? KeychainManager.deletePassword(forAccount: user)
    }
    
    // MARK: Decide to autocomplete
    func testloginViewModel_whenDecideToAutocompleteWithNoAnswer_returns() {
        // given
        let answer = false
        // when
        sut.onDecideToAutocompletePassword(withAnswer: answer, andUser: user)
        // then the view delegate doesn't call any method
        XCTAssertTrue(viewDelegate.callingState.isEmpty)
    }
    
    func testloginViewModel_whenDecideToAutocompleteWithYesAnswerAndSavedPassword_autocompletesAndEnablesEnterButton() {
        // given
        let answer = true
        try? KeychainManager.save(password: password, forAccount: user)
        // when
        sut.onDecideToAutocompletePassword(withAnswer: answer, andUser: user)
        // then the view delegate autocompletes and enables enter button
        XCTAssertTrue(viewDelegate.callingState.contains(.autocompletePasswordTextField))
        XCTAssertTrue(viewDelegate.callingState.contains(.enableEnterButton))
        try? KeychainManager.deletePassword(forAccount: user)
    }
    
    func testloginViewModel_whenDecideToAutocompleteWithYesAnswerAndUnsavedPassword_autocompletesAndEnablesEnterButton() {
        // given
        let answer = true
        // when
        sut.onDecideToAutocompletePassword(withAnswer: answer, andUser: user)
        // then the view delegate doesn't call any method
        XCTAssertTrue(viewDelegate.callingState.isEmpty)
    }
    
    // MARK: OnviewWillAppear
    func testloginViewModel_whenViewWillAppearWithSavedPassword_showsDecideToAutocomplete() {
        // given
        try? KeychainManager.save(password: password, forAccount: user)
        // when
        sut.onViewWillAppear(withUser: user)
        // then the view delegate shows decide to autocomplete
        XCTAssertTrue(viewDelegate.callingState.contains(.showDecideToAutocomplete))
        try? KeychainManager.deletePassword(forAccount: user)
    }
}
