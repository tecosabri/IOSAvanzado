//
//  File: WelcomeViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation

protocol WelcomeViewModelProtocol: AnyObject {
    func onViewLoad()
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
    func onViewLoad() {
        self.viewDelegate?.fadeOutBackgroundImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.viewDelegate?.navigateToLoginScene()
        }
    }
}
