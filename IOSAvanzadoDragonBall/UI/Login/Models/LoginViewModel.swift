//
//  File: LoginViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit
import RegexBuilder

enum LoginErrors: Error {
    case userMail(error: String)
}

protocol LoginViewModelProtocol: AnyObject {
    func onViewLoad()
    func onPressEnterButton(withUser user: String, andPassword password: String)
    func onPasswordTextFieldBeginEditing(withUser user: String)
    func onUserTextFieldReturnKey()
    func onPasswordTextFieldEditChange(withUser user: String, andPassword password: String)
    func onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs isEnabled: Bool)
    func onDecideToSavePassword(withAnswer answer: Bool)
}
    
    class LoginViewModel {
        
        // MARK: - Private properties
        // MVC properties
        private weak var viewDelegate: LoginViewControllerProtocol?
        
        // MARK: - Lifecycle
        init(viewDelegate: LoginViewControllerProtocol) {
            self.viewDelegate = viewDelegate
        }
    }
    
    // MARK: - LoginViewModelProtocol extension
    extension LoginViewModel: LoginViewModelProtocol {
        
        func onViewLoad() {
            viewDelegate?.focusUserTextField()
            viewDelegate?.hideBackButton()
            viewDelegate?.fadeIn()
        }
        
        // MARK: - Login functions
        func onPressEnterButton(withUser user: String, andPassword password: String) {
            // Set activity indicator to show that login is ocurring
            viewDelegate?.switchActivityIndicator()
            // Check if password is already in keychain
//            guard let password = try? KeychainManager.getPassword(forAccount: user) else {
//                // TODO: SHOW POPUP TO AUTOCOMPLETE
//                return
//            }
            // TODO: Save password, update (updating when error thrown is .duplicatedEntry) if needed, delete..
            // First check if user is in keychain. If its in keychain show autocomplete option
            login(withUser: user, andPassword: password) // If login error, show login error (manage login errors showing popup)
        }
        
        private func check(user: String) -> Bool{
            // Get mail regex to check user mail
            let mailRegex = getMailRegex()
            // Check user and send error if not matched
            guard user.wholeMatch(of: mailRegex) != nil else {
                return false
            }
            return true
        }
        
        
        private func getMailRegex() -> Regex<Substring> {
            // Create mail regex parts
            let recipientName = /^[A-Za-z0-9_\-!#$%&'*+\/=?^`{|]+/  // All possible characters before ampersand at least one time hisme14
            
            let domainName = /[A-Za-z0-9\-]+/
            let topLevelDomain = /\.[a-z]+$/
            // Create mail regex struct capturing the recipient and domain names
            let mailRegex = Regex {
                recipientName
                /@/
                domainName
                topLevelDomain
            }
            return mailRegex
        }
        
        private func login(withUser user: String, andPassword password: String) { // TODO: ADD CLOSURE TO SEND USER AND PASSWORD TO VIEWCONTROLLER (MIN 1:14 4 CLASE)
            let networkHelper = NetworkHelper()
            
            networkHelper.login(withUser: user, andPassword: password) { token, error in
                // Check null error and not nil token. Show alerts if needed
                self.check(error: error)
                self.check(token: token)
                
                // Sent to main as it involves UI modifications
                DispatchQueue.main.async {
                    self.viewDelegate?.switchActivityIndicator()
                    self.viewDelegate?.navigateToMap()
                    self.viewDelegate?.swipePasswordContent()
                    self.viewDelegate?.disableEnterButton()
                }
            }
        }
        
        private func check(error: NetworkError?) {
            guard error == nil else {
                DispatchQueue.main.async {
                    self.viewDelegate?.switchActivityIndicator()
                    self.viewDelegate?.showLoginErrorAlert(withMessage: "Incorrect password")
                }
                return
            }
        }
        private func check(token: String?) {
            guard token != nil else {
                DispatchQueue.main.async {
                    self.viewDelegate?.switchActivityIndicator()
                }
                return
            }
        }
        
        private func isPasswordAlreadySaved(forAccount account: String) -> Bool {
            guard (try? KeychainManager.getPassword(forAccount: account)) != nil else {return false}
        }
        
        func onPasswordTextFieldBeginEditing(withUser user: String) {
            // Mail check with error handling
            guard check(user: user) == true else {
                viewDelegate?.showUserErrorAlert(withMessage: "User mail has not the correct format")
                return
            }
        }
        
        func onPasswordTextFieldEditChange(withUser user: String, andPassword password: String) {
            if user.count > 0 && password.count > 3 {
                viewDelegate?.enableEnterButton()
            } else {
                viewDelegate?.disableEnterButton()
            }
        }
        
        func onUserTextFieldReturnKey() {
            viewDelegate?.focusPasswordTextField()
        }
        
        func onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs isEnabled: Bool) {
            if isEnabled {
                viewDelegate?.pushEnterButton()
            }
        }
        
        func onDecideToSavePassword(withAnswer answer: Bool) {
            KeychainManager.
        }
}

