//
//  CoreDataManagerTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class CoreDataManagerTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var networkHelper: NetworkHelper!
    private var coreDataManager: CoreDataManager!
    private var networkHelperTest: NetworkHelperTests!
    var sut: CoreDataManager!

    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionMock()
        coreDataManager = CoreDataManager()
        networkHelper = NetworkHelper(urlSession: urlSessionMock)
        networkHelperTest = NetworkHelperTests()
        sut = CoreDataManager()
    }

    override func tearDown() {
        sut = nil
        urlSessionMock = nil
        coreDataManager = nil
        networkHelper = nil
        super.tearDown()
    }

    func testCoreDataManager_whenFetchHeroWithPredicate_fetchSuccess() {
        //Given
        var hero: [Hero] = []
        networkHelper.token = "testToken"
        urlSessionMock.data = networkHelperTest.getDataFrom(resourceName: "heroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let predicate = NSPredicate(format: "name == 'Hero Name'")
        
        //When loaded a hero into coredata and fetch it with predicate
        let expectation = XCTestExpectation(description: "Expectation")
        networkHelper.getHeroes { heroes, _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
        hero = coreDataManager.fetchObjects(withPredicate: predicate)
        //Then
        XCTAssertEqual(hero[0].name, "Hero Name")
        self.coreDataManager.deleteCoreData(element: "Hero")
    }

}
