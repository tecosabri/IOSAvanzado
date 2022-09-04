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
    func onPressEnterButton(withUser user: String, andPassword password: String)
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
    
    // MARK: - Login functions
    func onPressEnterButton(withUser user: String, andPassword password: String) {
        // Mail check with error handling
        do {
            try check(user: user)
        } catch LoginErrors.userMail(let errorString){
            print("Error: \(errorString)")
        } catch {
            print("Unknown error")
        }
        login(withUser: user, andPassword: password)
    }
    
    private func check(user: String) throws {
        // Create mail regex parts
        let recipientName = /^[A-Za-z0-9_\-!#$%&'*+\/=?^`{|]+/  // All possible characters before ampersand at least one time hisme14
        let ampersand = /@/
        let domainName = /[A-Za-z0-9\-]+/
        let topLevelDomain = /\.[a-z]+$/
        // Create mail regex struct capturing the recipient and domain names
        let mailRegex = Regex {
            Capture{recipientName} // This item is match.1 as match.0 is the wholeMatch
            Capture{ampersand}
            Capture{domainName}
            Capture{topLevelDomain}
        }
        // Check user and send error if not matched
        guard user.wholeMatch(of: mailRegex) != nil else {
            throw LoginErrors.userMail(error: "User mail has not the correct format")
        }
    }
    
    private func login(withUser user: String, andPassword password: String) {
        let networkHelper = NetworkHelper()
        networkHelper.login(withUser: user, andPassword: password) { token, error in

            guard error == nil else {
                // TODO: Manage errors
                print("An error has occurred while login")
                return
            }
            
            guard token != nil else {
                // TODO: Manage no token
                print("No token received while login")
                return
            }
            
            // TODO: Save password, update (updating when error thrown is .duplicatedEntry) if needed, delete..
            
            
            // Navigate to map involves UIUpdate -> send to main thread
            DispatchQueue.main.async {
                self.viewDelegate?.navigateToMap()
            }
        }
    }
    
    
    
}
