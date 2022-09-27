//
//  LoginViewControllerSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 27/9/22.
//

import UIKit
@testable import IOSAvanzadoDragonBall

enum LoginViewControllerCalling {
    case hideBackButton,
         fadeIn,
         switchActivityIndicator,
         showLoginErrorAlert,
         showUserErrorAlert,
         showDecideToSave,
         showDecideToAutocomplete,
         navigateToMap,
         focusUserTextField,
         focusPasswordTextField,
         enableEnterButton,
         disableEnterButton,
         pushEnterButton,
         swipePasswordContent,
         autocompletePasswordTextField,
         showAlert
}

class LoginViewControllerSpy: LoginViewControllerProtocol {
    
    var callingState: [LoginViewControllerCalling] = []
    
    func hideBackButton() {
        callingState.append(.hideBackButton)
    }
    
    func fadeIn() {
        callingState.append(.fadeIn)
    }
    
    func switchActivityIndicator() {
        callingState.append(.switchActivityIndicator)
    }
    
    func showLoginErrorAlert(withMessage message: String) {
        callingState.append(.showLoginErrorAlert)
    }
    
    func showUserErrorAlert(withMessage message: String) {
        callingState.append(.showUserErrorAlert)
    }
    
    func showDecideToSave(password: String, forUser user: String, withTitle title: String) {
        callingState.append(.showDecideToSave)
    }
    
    func showDecideToAutocomplete(withTitle title: String, andUser user: String) {
        callingState.append(.showDecideToAutocomplete)
    }
    
    func navigateToMap(withToken token: String?) {
        callingState.append(.navigateToMap)
    }
    
    func focusUserTextField() {
        callingState.append(.focusUserTextField)
    }
    
    func focusPasswordTextField() {
        callingState.append(.focusPasswordTextField)
    }
    
    func enableEnterButton() {
        callingState.append(.enableEnterButton)
    }
    
    func disableEnterButton() {
        callingState.append(.disableEnterButton)
    }
    
    func pushEnterButton() {
        callingState.append(.pushEnterButton)
    }
    
    func swipePasswordContent() {
        callingState.append(.swipePasswordContent)
    }
    
    func autocompletePasswordTextField(withPassword password: String) {
        callingState.append(.autocompletePasswordTextField)
    }
    
    func showAlert(withMessage message: String) {
        callingState.append(.showAlert)
    }
}
