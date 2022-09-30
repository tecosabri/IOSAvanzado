//
//  File: WelcomeViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit

protocol WelcomeViewControllerProtocol: AnyObject {
    func navigateToLoginScene()
    func fadeOutBackgroundImage()
    func navigateToMap(withToken token: String)
}

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleImage: UIImageView!
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: WelcomeViewModelProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel?.onViewLoad()
    }
    
    private func setViewModel() {
        self.viewModel = WelcomeViewModel(viewDelegate: self)
    }
}

// MARK: - WelcomeViewControllerProtocol extension
extension WelcomeViewController: WelcomeViewControllerProtocol {
    func navigateToLoginScene() {
        navigationController?.pushViewController(LoginViewController(nibName: "LoginView", bundle: nil), animated: false)
    }
    
    func fadeOutBackgroundImage() {
        UIViewPropertyAnimator(duration: 2, curve: .easeOut, animations: {
            self.titleImage.alpha = 0
        }).startAnimation()
    }
    
    func navigateToMap(withToken token: String) {
        let mapViewController = MapViewController(nibName: "MapView", bundle: nil)
        mapViewController.setViewModel(withToken: token)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}


