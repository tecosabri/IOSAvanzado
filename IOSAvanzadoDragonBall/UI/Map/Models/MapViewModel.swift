//
//  File: MapViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation

protocol MapViewModelProtocol: AnyObject {
    
}

class MapViewModel {
    
    // MARK: - Private properties
    // MVC properties
    private weak var viewDelegate: MapViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(viewDelegate: MapViewControllerProtocol) {
        self.viewDelegate = viewDelegate
    }
}

// MARK: - MapViewModelProtocol extension
extension MapViewModel: MapViewModelProtocol {
    
}
