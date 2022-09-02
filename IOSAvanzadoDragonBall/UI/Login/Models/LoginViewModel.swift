//
//  File: LoginViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func onPressEnterButton()
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
    func onPressEnterButton() {
        viewDelegate?.navigateToMap()
    }
}
