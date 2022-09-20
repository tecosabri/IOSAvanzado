//
//  MKMapViewExtension.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 11/9/22.
//

import UIKit
import MapKit

extension MKMapView {
    
    func centerTo(location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
}
