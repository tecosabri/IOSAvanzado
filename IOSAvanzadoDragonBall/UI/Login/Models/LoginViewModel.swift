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
    func onUserTextFieldReturnKey(withUser user: String)
    func onPasswordTextFieldEditChange(withUser user: String, andPassword password: String)
    func onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs isEnabled: Bool)
    func onDecideToSave(password: String, forUser user: String, withAnswer answer: Bool)
    func onDecideToAutocompletePassword(withAnswer answer: Bool, andUser user: String)
    func onViewWillAppear(withUser user: String)
}

class LoginViewModel {
    
    // MARK: - Constants
    private let networkHelper = NetworkHelper()
    
    // MARK: - Variables
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
        // Login if needed: checks login errors
        guard let token = try? KeychainManager.getPassword(forAccount: "DragonBall") else {
            networkHelper.login(withUser: user, andPassword: password) { token, error in
                // Check null error and not nil token. Show alerts if needed
                self.check(error: error)
                self.check(token: token)
                guard let token = token else { return}
                try? KeychainManager.save(password: token, forAccount: "DragonBall")
                
                // Sent to main as it involves UI modifications
                DispatchQueue.main.sync {
                    self.viewDelegate?.switchActivityIndicator()
                    self.viewDelegate?.swipePasswordContent()
                    self.viewDelegate?.navigateToMap(withToken: token)
                    self.saveOrNotSave(password: password, forUser: user)
                    self.viewDelegate?.disableEnterButton()
                }
            }
            return
        }
        
        
        self.viewDelegate?.switchActivityIndicator()
        self.viewDelegate?.swipePasswordContent()
        self.viewDelegate?.navigateToMap(withToken: token)
        self.viewDelegate?.disableEnterButton()
        
    }
    
    private func check(error: NetworkError?) {
        guard error == nil else {
            DispatchQueue.main.async {
                // Stop activity indicator
                self.viewDelegate?.switchActivityIndicator()
                // Manage errors
                switch error {
                case .other, .malformedURL, .tokenFormat, .decoding:
                    self.viewDelegate?.showLoginErrorAlert(withMessage: "An error occurred while login")
                case .noData, .errorCode(401):
                    self.viewDelegate?.showLoginErrorAlert(withMessage: "Incorrect usermail or password")
                    return
                case .errorCode(let code):
                    guard let code = code else {
                        self.viewDelegate?.showLoginErrorAlert(withMessage: "An error occurred while login")
                        return
                    }
                    self.viewDelegate?.showLoginErrorAlert(withMessage: "HTTP Error \(code)")
                case .none:
                    return
                }
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
    private func saveOrNotSave(password: String, forUser user: String) {
        guard isPasswordAlreadySaved(forAccount: user) == false else {return}
        self.viewDelegate?.showDecideToSave(password: password, forUser: user, withTitle: "Save password for user mail \(user)?")
    }
    
    func onPasswordTextFieldBeginEditing(withUser user: String) {
        // Mail check with error handling
        guard check(user: user) == true else {
            viewDelegate?.showUserErrorAlert(withMessage: "User mail has not the correct format")
            return
        }
    }
    
    private func check(user: String) -> Bool{
        // Check user and send error if not matched mail regex
        guard user.wholeMatch(of: RegexHelper.getMailRegex()) != nil else {
            return false
        }
        return true
    }
    
    private func isPasswordAlreadySaved(forAccount account: String) -> Bool {
        guard (try? KeychainManager.getPassword(forAccount: account)) != nil else {return false}
        return true
    }
    
    func onPasswordTextFieldEditChange(withUser user: String, andPassword password: String) {
        if user.count > 0 && password.count > 3 {
            viewDelegate?.enableEnterButton()
        } else {
            viewDelegate?.disableEnterButton()
        }
    }
    
    func onUserTextFieldReturnKey(withUser user: String) {
        viewDelegate?.focusPasswordTextField()
        
        // Autocomplete check
        if isPasswordAlreadySaved(forAccount: user) {
            viewDelegate?.showDecideToAutocomplete(withTitle: "Autocomplete password for user mail \(user)?", andUser: user)
        }
    }
    
    func onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs isEnabled: Bool) {
        if isEnabled {
            viewDelegate?.pushEnterButton()
        }
    }
    
    func onDecideToSave(password: String, forUser user: String, withAnswer answer: Bool) {
        guard answer == true else {return}
        
        do {
            try KeychainManager.save(password: password, forAccount: user)
        } catch {
            viewDelegate?.showAlert(withMessage: "Unable to save the password")
        }
    }
    
    func onDecideToAutocompletePassword(withAnswer answer: Bool, andUser user: String) {
        guard answer == true else {
            return
        }
        guard let password = try? KeychainManager.getPassword(forAccount: user) else {return}
        viewDelegate?.autocompletePasswordTextField(withPassword: password)
        viewDelegate?.enableEnterButton()
    }
    
    func onViewWillAppear(withUser user: String) {
        if isPasswordAlreadySaved(forAccount: user) {
            viewDelegate?.showDecideToAutocomplete(withTitle: "Autocomplete password for user mail \(user)?", andUser: user)
        }
    }
}

