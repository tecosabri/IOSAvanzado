//
//  File: MapViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation
import CoreLocation


protocol MapViewModelProtocol: AnyObject {
    func onViewWillAppear()
    func onViewDidAppear()
}

class MapViewModel {
    
    // Mark: - Constants
    private let coreDataManager = CoreDataManager()
    private let networkHelper: NetworkHelper

    
    // MARK: - Variables
    // MVC properties
    private weak var viewDelegate: MapViewControllerProtocol?
    
    // MARK: - Lifecycle
    init(viewDelegate: MapViewControllerProtocol, withToken token: String?) {
        self.viewDelegate = viewDelegate
        self.networkHelper = NetworkHelper(token: token)
    }

}

// MARK: - MapViewModelProtocol extension
extension MapViewModel: MapViewModelProtocol {
    func onViewWillAppear() {
        saveHeroesAndTheirLocationsToCoreData()
    }
    private func saveHeroesAndTheirLocationsToCoreData() {
        networkHelper.getHeroes { heroes, _ in
            heroes.forEach {
                let hero = self.coreDataManager.create(hero: $0)
                // For each hero, get his locations and add it to coredata
                self.networkHelper.getLocations(id: $0.id) { locations, error in
                    for location in locations {
                        let context = self.coreDataManager.container.viewContext
                        let cdLocation = self.coreDataManager.create(location: location)
                        hero.addToLocations(cdLocation)
                        cdLocation.addToHeroe(hero)
                        do {
                            try context.save()
                        } catch {
                            print("Unable to save location")
                        }
                    }
                }
            }
        }
    }
    
    func onViewDidAppear() {
        viewDelegate?.setUpLocation()
    }
}

