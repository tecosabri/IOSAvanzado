//
//  MapViewModelSpy.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 28/9/22.
//

import UIKit
import MapKit
@testable import IOSAvanzadoDragonBall

enum MapViewModelCalling {
    case onViewWillAppear,
         onUpdateSearchResults,
         onSelected,
         onPressedInfoButtonOn,
         onViewWillDisappear
}

class MapViewModelSpy: MapViewModelProtocol {
    
    var callingState: [MapViewModelCalling] = []

    func onViewWillAppear() {
        callingState.append(.onViewWillAppear)
    }
    
    func onUpdateSearchResults(for searchController: UISearchController) {
        callingState.append(.onUpdateSearchResults)
    }
    
    func onSelected(annotation: MKAnnotationView) {
        callingState.append(.onSelected)
    }
    
    func onPressedInfoButtonOn(annotation: MKAnnotationView) {
        callingState.append(.onPressedInfoButtonOn)
    }
    
    func onViewWillDisappear(withNavigationController navigationController: UINavigationController?) {
        callingState.append(.onViewWillDisappear)
    }
}
