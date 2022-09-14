//
//  File: MapViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation
import CoreLocation
import MapKit


protocol MapViewModelProtocol: AnyObject {
    func onViewWillAppear()
}

class MapViewModel {
    
    // Mark: - Constants
    private let coreDataManager = CoreDataManager()
    private let networkHelper: NetworkHelper
    typealias FinishedHeroFetching = (Heroe) -> ()
    typealias FinishedLocationsFetching = (MKPointAnnotation) -> ()

    
    // MARK: - Variables
    // MVC properties
    private weak var viewDelegate: MapViewControllerProtocol?
    // Other properties
    private var heroes: [Heroe] = []
    private var locations: [CDLocation] = []
    private var annotations: [MKPointAnnotation] = []
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Lifecycle
    init(viewDelegate: MapViewControllerProtocol, withToken token: String?) {
        self.viewDelegate = viewDelegate
        self.networkHelper = NetworkHelper(token: token)
    }

}

// MARK: - MapViewModelProtocol extension
extension MapViewModel: MapViewModelProtocol {
    func onViewWillAppear() {
        // Set location to user location
        self.viewDelegate?.setUpLocation()
        // Get heroes their locations and annotations. Each time a hero is saved, pin his annotation on the map
        
        self.getHeroes { hero in
            self.getLocations(forHero: hero) { annotation in
                self.add(annotation: annotation)
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.viewDelegate?.switchLoadingHerosLabel()
        }
        deleteCoredata() // TODO: Deleting elements, provisionnally
    }
    
    private func getHeroes(completion: @escaping FinishedHeroFetching) {
        dispatchGroup.enter()
        guard heroes.count == 0 else {return}
        networkHelper.getHeroes { heroes, _ in
            heroes.forEach {
                // Add hero to coredata
                let hero = self.coreDataManager.create(hero: $0)
                // Add hero to array
                self.heroes.append(hero)
                // Add locations
                completion(hero)
            }
            self.dispatchGroup.leave()
        }
    }
    private func getLocations(forHero hero: Heroe, completion: @escaping FinishedLocationsFetching) {
        dispatchGroup.enter()
        guard let id = hero.id,
              let name = hero.name
        else {return}

        networkHelper.getLocations(id: id) { locationModels, error in
                locationModels.forEach {
                    // Add location to coredata
                    let location = self.coreDataManager.create(location: $0)
                    // Add location to array
                    self.locations.append(location)
                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = name
                    guard let latitude = Double(location.latitud ?? "") else {return}
                    guard let longitude = Double(location.longitud ?? "") else {return}
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    completion(annotation)
                }
            self.dispatchGroup.leave()
            }
        
    }
    private func add(annotation: MKPointAnnotation) {
        annotations.append(annotation)
        viewDelegate?.pinPoint(annotation: annotation)
        print("Annotation \(annotation.description) has been added")
    }

    private func deleteCoredata() {
        coreDataManager.deleteCoreData(element: "Heroe")
        coreDataManager.deleteCoreData(element: "CDLocation")
    }
}

