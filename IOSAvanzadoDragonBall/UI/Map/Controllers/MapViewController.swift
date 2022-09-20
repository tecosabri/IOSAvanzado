//
//  File: MapViewController.swift
//
//  Created by Ismael Sabri on 2/9/22.
//  Copyright (c) 2022 Ismael Sabri. All rights reserved.
//
import UIKit
import MapKit

protocol MapViewControllerProtocol: AnyObject {
    func setUpLocation()
    func centerTo(location: CLLocation)
    func pinPoint(annotation: MKPointAnnotation)
    func switchLoadingHerosLabel()
    func setSearchBar()
    func deleteAnnotations()
    func navigateToDetailOf(hero: Hero, shownOn dateShow: String)
}

class MapViewController: UIViewController {
    
    // MARK: - Constants
    private let locationManager = CLLocationManager()
    
    // MARK: - Variables
    // MVC properties
    var viewModel: MapViewModelProtocol?
    // MARK: - IBOutlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var loadingHerosLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
    }

    func setViewModel(withToken token: String?) {
        self.viewModel = MapViewModel(viewDelegate: self, withToken: token)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.onViewWillAppear()
    }

}

// MARK: - MapViewControllerProtocol extension
extension MapViewController: MapViewControllerProtocol, CLLocationManagerDelegate {
    func setUpLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        guard let userLocation = locationManager.location else {return}
        mapView.centerTo(location: userLocation)
    }
    
    func centerTo(location: CLLocation) {
        mapView.centerTo(location: location)
    }
    
    func pinPoint(annotation: MKPointAnnotation) {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func switchLoadingHerosLabel() {
        switch loadingHerosLabel.isHidden {
        case true:
            loadingHerosLabel.isHidden = false
        case false:
            loadingHerosLabel.isHidden = true
        }
    }
    
    func deleteAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func navigateToDetailOf(hero: Hero, shownOn dateShow: String) {
        let detailViewController = DetailViewController(nibName: "Detail", bundle: nil)
        detailViewController.setViewModel(withHero: hero, shownOn: dateShow)
        present(detailViewController, animated: true)
    }
}

// MARK: - SearchBar extension
extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.onUpdateSearchResults(for: searchController)
    }
    
    func setSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        // Set up search bar
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search your hero!"
        searchController.searchBar.setValue("Cancel", forKey: "cancelButtonText")

        navigationItem.searchController = searchController
    }
}

// MARK: - MKMapViewDelegate extension
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        viewModel?.onSelected(annotation: view)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        viewModel?.onPressedInfoButtonOn(annotation: view)
    }
}


