//
//  MapViewControllerSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 29/9/22.
//

import UIKit
import MapKit
@testable import IOSAvanzadoDragonBall

enum MapViewControllerCalling {
    case setUpLocation,
         centerTo,
         pinPoint,
         switchLoadingHerosLabel,
         setSearchBar,
         deleteAnnotations,
         navigateToDetailOf,
         navigateToLoginScene,
         setLogOutButton
}

class MapViewControllerSpy: MapViewControllerProtocol {
    
    var callingState: [MapViewControllerCalling] = []

    func setUpLocation() {
        callingState.append(.setUpLocation)
    }
    
    func centerTo(location: CLLocation) {
        callingState.append(.centerTo)
    }
    
    func pinPoint(annotation: MKPointAnnotation) {
        callingState.append(.pinPoint)
    }
    
    func switchLoadingHerosLabel() {
        callingState.append(.switchLoadingHerosLabel)
    }
    
    func setSearchBar() {
        callingState.append(.setSearchBar)
    }
    
    func deleteAnnotations() {
        callingState.append(.deleteAnnotations)
    }
    
    func navigateToDetailOf(hero: IOSAvanzadoDragonBall.Hero, shownOn dateShow: String) {
        callingState.append(.navigateToDetailOf)
    }
    
    func navigateToLoginScene() {
        callingState.append(.navigateToLoginScene)
    }
    
    func setLogOutButton() {
        callingState.append(.setLogOutButton)
    }
}
