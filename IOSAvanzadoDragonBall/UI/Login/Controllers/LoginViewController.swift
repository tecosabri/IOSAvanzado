//
//  File: LoginViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    func hideBackButton()
    func fadeIn()
    func switchActivityIndicator()
    func showLoginErrorAlert(withMessage message: String)
    func showUserErrorAlert(withMessage message: String)
    func showDecideToSave(password: String, forUser user: String, withTitle title: String)
    func showDecideToAutocomplete(withTitle title: String, andUser user: String)
    func navigateToMap(withToken token: String?)
    func focusUserTextField()
    func focusPasswordTextField()
    func enableEnterButton()
    func disableEnterButton()
    func pushEnterButton()
    func swipePasswordContent()
    func autocompletePasswordTextField(withPassword password: String)
    func showAlert(withMessage message: String)
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var gokuImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: LoginViewModelProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel?.onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = userTextField.text else {return}
        viewModel?.onViewWillAppear(withUser: user)
    }
    
     func setViewModel() {
        self.viewModel = LoginViewModel(viewDelegate: self)
    }
    
    // MARK: - IBActions
    @IBAction func onPressEnterButton(_ sender: Any) {
        guard let user = userTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        viewModel?.onPressEnterButton(withUser: user, andPassword: password)
    }
    
    @IBAction func onPasswordTextFieldBeginEditing(_ sender: Any) {
        guard let user = userTextField.text else {return}
        viewModel?.onPasswordTextFieldBeginEditing(withUser: user)
    }
    
    @IBAction func onUserTextFieldReturnKey(_ sender: Any) {
        guard let user = userTextField.text else {return}
        viewModel?.onUserTextFieldReturnKey(withUser: user)
    }
    
    @IBAction func onPasswordTextFieldEditChange(_ sender: Any) {
        guard let user = userTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        viewModel?.onPasswordTextFieldEditChange(withUser: user, andPassword: password)
    }
    
    @IBAction func onPasswordTextFieldReturnKey(_ sender: Any) {
        let enterButtonIsEnabled = enterButton.isEnabled
        viewModel?.onPasswordTextFieldReturnKey(whenEnterButtonIsEnabledIs: enterButtonIsEnabled)
    }
    
    @IBAction func onUserTextFieldEndEdit(_ sender: Any) {
        guard let user = userTextField.text else {return}
        viewModel?.onUserTextFieldReturnKey(withUser: user)
    }
}

// MARK: - LoginViewControllerProtocol extension
extension LoginViewController: LoginViewControllerProtocol {
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    func fadeIn() {
        UIViewPropertyAnimator(duration: 4, curve: .easeOut, animations: {
            self.gokuImage.alpha = 1
        }).startAnimation()
    }
    
    func switchActivityIndicator() {
        switch activityIndicator.isAnimating {
        case true:
            activityIndicator.stopAnimating()
        case false:
            activityIndicator.startAnimating()
        }
    }
    
    func showLoginErrorAlert(withMessage message: String) {
        showOkAlert(withTitle: message) { _ in
            self.focusPasswordTextField()
        }
    }
    
    func showDecideToSave(password: String, forUser user: String, withTitle title: String) {
        showYesNoAlert(withTitle: title, andMessage: "") { answer in
            self.viewModel?.onDecideToSave(password: password, forUser: user, withAnswer: answer)
        }
    }
    
    func showDecideToAutocomplete(withTitle title: String, andUser user: String) {
        showYesNoAlert(withTitle: title, andMessage: "") { answer in
            self.viewModel?.onDecideToAutocompletePassword(withAnswer: answer, andUser: user)
        }
    }
    
    func navigateToMap(withToken token: String?) {
        let mapViewController = MapViewController(nibName: "MapView", bundle: nil)
        mapViewController.setViewModel(withToken: token)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func showUserErrorAlert(withMessage message: String) {
        showOkAlert(withTitle: message) { _ in
            self.focusUserTextField()
        }
    }
    
    func focusUserTextField() {
        userTextField.becomeFirstResponder()
    }

    func focusPasswordTextField() {
        passwordTextField.becomeFirstResponder()
    }
    
    func enableEnterButton() {
        enterButton.isEnabled = true
        enterButton.isHidden = false
    }
    
    func disableEnterButton() {
        enterButton.isEnabled = false
        enterButton.isHidden = true
    }
    
    func pushEnterButton() {
        guard let enterButton = enterButton else {return}
        self.onPressEnterButton(enterButton)
    }
    
    func swipePasswordContent() {
        passwordTextField.text = ""
    }
    
    func autocompletePasswordTextField(withPassword password: String) {
        passwordTextField.text = password
    }
    
    func showAlert(withMessage message: String) {
        showOkAlert(withTitle: message, completion: nil)
    }

}
