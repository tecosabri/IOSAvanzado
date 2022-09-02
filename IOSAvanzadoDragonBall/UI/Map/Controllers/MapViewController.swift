//
//  File: MapViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit

protocol MapViewControllerProtocol: AnyObject {
    
}

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    // MARK: - Public properties
    // MVC properties
    var viewModel: MapViewModelProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
    }
    
    private func setViewModel() {
        self.viewModel = MapViewModel(viewDelegate: self)
    }
}

// MARK: - MapViewControllerProtocol extension
extension MapViewController: MapViewControllerProtocol {
    
}
