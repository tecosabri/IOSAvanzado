//
//  MapViewModelTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 28/9/22.
//

import XCTest
import MapKit
@testable import IOSAvanzadoDragonBall

final class MapViewModelTests: XCTestCase {

    var sut: MapViewModel!
    var mapViewControllerSpy: MapViewControllerSpy!
    var mockToken =
    """
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InByaXZhdGUifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiI3QUI4QUM0RC1BRDhGLTRBQ0UtQUE0NS0yMUU4NEFFOEJCRTciLCJlbWFpbCI6ImJlamxAa2VlcGNvZGluZy5lcyJ9.UQkianJsXDCQyUw-2QUPOL0aY2Vq-maWoHGYSJkzI9Q
    """
    
    override func setUp() {
        super.setUp()
        mapViewControllerSpy = MapViewControllerSpy()
        sut = MapViewModel(viewDelegate: mapViewControllerSpy, withToken: mockToken)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testMapViewModel_whenPressedInfoButtonOnAnnotation_navigateToDetailOfHero() {
        // given
        let annotationView = MKAnnotationView()
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = "Hero Name"
        pointAnnotation.subtitle = "Subtitle"
        annotationView.annotation = pointAnnotation
        
        guard let heroData = NetworkHelperTests().getDataFrom(resourceName: "heroes") else {return}
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let decoder = JSONDecoder(context: context)
        guard (try? decoder.decode([Hero].self, from: heroData)) != nil else {return}
        
        // when
        sut.onPressedInfoButtonOn(annotation: annotationView)
        // then
        XCTAssertTrue(mapViewControllerSpy.callingState.contains(.navigateToDetailOf))
        CoreDataManager().deleteCoreData(element: "Hero")
    }
    
    func testMapViewModel_whenViewWillDisappearPreviousViewControllerIsWelcomeViewController_navigateToLoginScene() {
        // given
        let navigationController = UINavigationController(rootViewController: WelcomeViewController())
        // when
        sut.onViewWillDisappear(withNavigationController: navigationController)
        // then
        XCTAssertTrue(mapViewControllerSpy.callingState.contains(.navigateToLoginScene))
    }
    
}
