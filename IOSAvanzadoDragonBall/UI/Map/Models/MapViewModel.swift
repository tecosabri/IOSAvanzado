//
//  File: MapViewModel.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import Foundation
import CoreLocation
import MapKit
import CoreData


protocol MapViewModelProtocol: AnyObject {
    func onViewWillAppear()
    func onUpdateSearchResults(for searchController: UISearchController)
}

class MapViewModel {
    
    // Mark: - Constants
    private let coreDataManager = CoreDataManager()
    private let networkHelper: NetworkHelper
    typealias FinishedHeroFetching = (Hero) -> ()
    typealias FinishedLocationsFetching = (MKPointAnnotation) -> ()
    
    
    // MARK: - Variables
    // MVC properties
    private weak var viewDelegate: MapViewControllerProtocol?
    // Other properties
    private var heroes: [Hero] = []
    private var locations: [Location] = []
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
        
        heroes = coreDataManager.fetchObjects()
        locations = coreDataManager.fetchObjects()

        if heroes.count == 0 {
            // Get heroes their locations and annotations. Each time a hero is saved, pin his annotation on the map
            self.getHeroes { hero in
                self.getLocations(forHero: hero) { annotation in
                    self.add(annotation: annotation)
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.heroes = self.coreDataManager.fetchObjects()
                // Set search bar
                self.viewDelegate?.setSearchBar()
                // Switch label, indicanting that heros and locations were succesfully loaded
                self.viewDelegate?.switchLoadingHerosLabel()
            }
        }
        
        if heroes.count > 0 {
            locations.forEach { location in
                guard let annotation = self.getAnnotation(forLocation: location, withTitle: location.hero?.name ?? "noname") else {return}
                self.add(annotation: annotation)
            }
            self.viewDelegate?.setSearchBar()
            // Switch label, indicanting that heros and locations were succesfully loaded
            self.viewDelegate?.switchLoadingHerosLabel()
        }
        
    }
    private func getHeroes(completion: @escaping FinishedHeroFetching) {
        dispatchGroup.enter()
        networkHelper.getHeroes { heroes, _ in
            heroes.forEach {
                // Add locations
                completion($0)
            }
            self.dispatchGroup.leave()
        }
    }
    private func getLocations(forHero hero: Hero, completion: @escaping FinishedLocationsFetching) {
        dispatchGroup.enter()
        guard let id = hero.id,
              let name = hero.name
        else {return}
        
        networkHelper.getLocations(id: id) { locationModels, error in
            // Set the locations for each hero
            hero.locations = NSSet(array: locationModels)
            
            locationModels.forEach {
                // Set the hero for each location
                $0.hero = hero
                // Add annotation
                guard let annotation = self.getAnnotation(forLocation: $0, withTitle: name) else {return}
                completion(annotation)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getAnnotation(forLocation location: Location, withTitle title: String) -> MKPointAnnotation? {
        let annotation = MKPointAnnotation()
        annotation.title = title
        guard let latitude = Double(location.latitude ?? "") else {return nil}
        guard let longitude = Double(location.longitude ?? "") else {return nil}
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
    private func add(annotation: MKPointAnnotation) {
        annotations.append(annotation)
        viewDelegate?.pinPoint(annotation: annotation)
    }
    
    private func deleteCoredata() {
        coreDataManager.deleteCoreData(element: "Hero")
        coreDataManager.deleteCoreData(element: "Location")
    }
    
    func onUpdateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text,
              !search.isEmpty
        else {
            addAllExistentHeroesAndLocations()
            return
        }
        // Delete map annotations
        viewDelegate?.deleteAnnotations()
        // Add filtered annotations
        for hero in heroes where hero.name!.localizedCaseInsensitiveContains(search) {
            guard let name = hero.name else {return}
            for location in locations where location.heroId == hero.id {
                guard let annotation = getAnnotation(forLocation: location, withTitle: name) else {return}
                add(annotation: annotation)
            }
        }
    }
    private func addAllExistentHeroesAndLocations() {
        viewDelegate?.deleteAnnotations()
        heroes = coreDataManager.fetchObjects()
        locations = coreDataManager.fetchObjects()
        for hero in heroes {
            guard let name = hero.name else {return}
            for location in locations where location.heroId == hero.id {
                guard let annotation = getAnnotation(forLocation: location, withTitle: name) else {return}
                add(annotation: annotation)
            }
        }
    }
}

