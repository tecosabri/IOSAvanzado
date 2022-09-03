//
//  File: LoginViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    func navigateToMap()
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: LoginViewModelProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
    }
    
    private func setViewModel() {
        self.viewModel = LoginViewModel(viewDelegate: self)
    }
    
    // MARK: - IBActions
    @IBAction func onPressEnterButton(_ sender: Any) {
        // TODO: Check nil pass and user, not empty etc
        guard let user = userTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        viewModel?.onPressEnterButton(withUser: user, andPassword: password)
    }
}

// MARK: - LoginViewControllerProtocol extension
extension LoginViewController: LoginViewControllerProtocol {
    func navigateToMap() {
        navigationController?.pushViewController(MapViewController(nibName: "MapView", bundle: nil), animated: true)
    }
    

}
