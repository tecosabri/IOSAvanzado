//
//  LoginViewModelSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 26/9/22.
//

import Foundation
@testable import IOSAvanzadoDragonBall

enum LoginViewModelCalledMethod {
    case onViewLoad,
         onPressEnterButton,
         onPasswordTextFieldBeginEditing,
         onUserTextFieldReturnKey,
         onPasswordTextFieldEditChange,
         onPasswordTextFieldReturnKey,
         onDecideToSave,
         onDecideToAutocompletePassword,
         onViewWillAppear
}

class LoginViewModelSpy: LoginViewModelProtocol {
    
    var calledMethod: LoginViewModelCalledMethod?
    
    func onViewLoad() {
        calledMethod = .onViewLoad
    }
    
    func onPressEnterButton(withUser user: String, andPassword password: String) {
        calledMethod = .onPressEnterButton
    }
    
    func onPasswordTextFieldBeginEditing(withUser user: String) {
        calledMethod = .onPasswordTextFieldBeginEditing
    }
    
    func onUserTextFieldReturnKey(withUser user: String) {
        calledMethod = .onUserTextFieldReturnKey
    }
    
    func onPasswordTextFieldEditChange(withUser user: String, andPassword password: String) {
        calledMethod = .onPasswordTextFieldEditChange
    }
    
    func onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs isEnabled: Bool) {
        calledMethod = .onPasswordTextFieldReturnKey
    }
    
    func onDecideToSave(password: String, forUser user: String, withAnswer answer: Bool) {
        calledMethod = .onDecideToSave
    }
    
    func onDecideToAutocompletePassword(withAnswer answer: Bool, andUser user: String) {
        calledMethod = .onDecideToAutocompletePassword
    }
    
    func onViewWillAppear(withUser user: String) {
        calledMethod = .onViewWillAppear
    }
    
    
}
