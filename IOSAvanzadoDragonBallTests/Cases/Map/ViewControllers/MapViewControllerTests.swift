//
//  MapViewControllerTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 28/9/22.
//

import XCTest
import MapKit
@testable import IOSAvanzadoDragonBall

final class MapViewControllerTests: XCTestCase {
    
    var sut: MapViewController?
    
    override func setUp() {
        super.setUp()
        sut = MapViewController()
        sut?.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testMapViewController_whenCalledViewWillDisappear_viewModelCallsOnViewWillDisappear() {
        // given
        // when
        let viewModelSpy = MapViewModelSpy()
        sut?.viewModel = viewModelSpy
        sut?.viewWillDisappear(true)
        // then view model calls method on view will disappear
        XCTAssertTrue(viewModelSpy.callingState.contains(.onViewWillDisappear))
    }
    
    func testMapViewController_whenCalledCenterTo_mapViewCallsCenterToLocation() {
        // given
        // when
        let viewModelSpy = MapViewModelSpy()
        sut?.viewModel = viewModelSpy
        sut?.viewWillDisappear(true)
        // then view model calls method on view will disappear
        XCTAssertTrue(viewModelSpy.callingState.contains(.onViewWillDisappear))
    }
    
    func testMapViewController_whenSwitchLoadingHerosHiddenLabel_labelShowsUp() {
        // given
        sut?.loadingHerosLabel.isHidden = true
        // when
        sut?.switchLoadingHerosLabel()
        guard let label = sut?.loadingHerosLabel else { return }
        // then the label is not hidden
        XCTAssertFalse(label.isHidden)
    }
    
    func testMapViewController_whenNavigateToDetail_presentedViewControllerIsDetail() {
        // given
        guard let sut else {return}
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: sut)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationControllerSpy
        window.makeKeyAndVisible()
        
        guard let heroData = NetworkHelperTests().getDataFrom(resourceName: "heroes") else {return}
        let decoder = JSONDecoder(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        let hero = try! decoder.decode([Hero].self, from: heroData)
        // when
        sut.navigateToDetailOf(hero: hero[0], shownOn: "2022-02-20T00:00:00Z")
        // then
        XCTAssertTrue(sut.presentedViewController is DetailViewController)
    }
    
    func testMapViewController_whenNavigateToLogin_pushedViewControllerIsLogin() {
        // given
        guard let sut else {return}
        let navigationControllerSpy = NavigationControllerSpy(rootViewController: sut)
        // when
        sut.navigateToLoginScene()
        // then the label is not hidden
        XCTAssertTrue(navigationControllerSpy.pushedViewController is LoginViewController)
    }

    func testMapViewController_whenSetLogoutButton_logoutButtonIsOnNavigationBar() {
        // given
        // when
        sut?.setLogOutButton()
        // then the label is not hidden
        XCTAssertEqual(sut?.navigationItem.rightBarButtonItem?.title, "Exit")
    }
    
    func testMapViewController_whenUpdateSearchResults_viewModelCallsOnUpdateSearchResults() {
        // given
        let mapViewModelSpy = MapViewModelSpy()
        sut?.viewModel = mapViewModelSpy
        // when
        sut?.updateSearchResults(for: UISearchController())
        // then the label is not hidden
        XCTAssertTrue(mapViewModelSpy.callingState.contains(.onUpdateSearchResults))
    }
    
    func testMapViewController_whenMapViewDidSelect_viewModelCallsOnSelected() {
        // given
        let mapViewModelSpy = MapViewModelSpy()
        sut?.viewModel = mapViewModelSpy
        guard let mapView = sut?.mapView else {return}
        // when
        mapView.delegate?.mapView?(mapView, didSelect: MKAnnotationView())
        // then the label is not hidden
        XCTAssertTrue(mapViewModelSpy.callingState.contains(.onSelected))
    }
    
    func testMapViewController_whenMapViewAnnotationView_viewModelCallsOnPressedInfoButton() {
        // given
        let mapViewModelSpy = MapViewModelSpy()
        sut?.viewModel = mapViewModelSpy
        guard let mapView = sut?.mapView else {return}
        // when
        mapView.delegate?.mapView?(mapView, annotationView: MKAnnotationView(), calloutAccessoryControlTapped: UIControl())
        // then the label is not hidden
        XCTAssertTrue(mapViewModelSpy.callingState.contains(.onPressedInfoButtonOn))
    }
    
    func testMapViewController_whenCenterToLocation_mapViewCentersToLocation() {
        // given
        guard let mapView = sut?.mapView else {return}
        let location = CLLocation(latitude: CLLocationDegrees(floatLiteral: 50.0), longitude: CLLocationDegrees(floatLiteral: 50.0))
        // when
        sut?.centerTo(location: location)
        // then the label is not hidden
        XCTAssertEqual(mapView.centerCoordinate.longitude, location.coordinate.latitude, accuracy: 0.0001)
        XCTAssertEqual(mapView.centerCoordinate.longitude, location.coordinate.longitude, accuracy: 0.0001)
    
    }
    
    func testMapViewController_whenPinPointAnotation_mapViewAddsAnnotation() {
        // given
        guard let mapView = sut?.mapView else {return}
        let annotation = MKPointAnnotation()
        annotation.title = "RandomTitle"
        annotation.coordinate.longitude = 50.0
        annotation.coordinate.latitude = 50.0
        // when
        sut?.pinPoint(annotation: annotation)
        // then the label is not hidden
        guard let mapViewAnnotationTitle = mapView.annotations[0].title else {return}
        XCTAssertEqual(mapViewAnnotationTitle, "RandomTitle")
    }
}

