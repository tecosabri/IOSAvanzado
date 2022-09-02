//
//  File: WelcomeViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit

protocol WelcomeViewControllerProtocol: AnyObject {
    func navigateToLoginScene()
}

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: WelcomeViewModelProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
    }
    
    private func setViewModel() {
        self.viewModel = WelcomeViewModel(viewDelegate: self)
    }
    
    // MARK: - IBFunctions
    @IBAction func onPressLoginButton(_ sender: Any) {
        viewModel?.onPressLoginButton()
    }
}

// MARK: - WelcomeViewControllerProtocol extension
extension WelcomeViewController: WelcomeViewControllerProtocol {
    func navigateToLoginScene() {
        navigationController?.pushViewController(LoginViewController(nibName: "LoginView", bundle: nil), animated: true)
    }
}
