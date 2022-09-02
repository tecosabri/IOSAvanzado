//
//  File: WelcomeViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation

protocol WelcomeViewModelProtocol: AnyObject {
    func onPressLoginButton()
}

class WelcomeViewModel {
    
    // MARK: - Private properties
    // MVC properties
    private weak var viewDelegate: WelcomeViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(viewDelegate: WelcomeViewControllerProtocol) {
        self.viewDelegate = viewDelegate
    }
}

// MARK: - WelcomeViewModelProtocol extension
extension WelcomeViewModel: WelcomeViewModelProtocol {
    func onPressLoginButton() {
        viewDelegate?.navigateToLoginScene()
    }
}
