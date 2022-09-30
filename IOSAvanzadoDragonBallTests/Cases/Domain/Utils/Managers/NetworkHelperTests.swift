//
//  NetworkModelTests.swift
//  Práctica Fundamentos iOSTests
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

enum ErrorMock: Error {
    case mockCase
}

class NetworkHelperTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: NetworkHelper!
    private var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        coreDataManager = CoreDataManager()
        sut = NetworkHelper(urlSession: urlSessionMock)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testNetworkHelper_whenNoData_loginFailWithNoDataError() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .noData)
    }
    
    func testNetworkHelper_whenMockError_loginFailWithOtherError() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        urlSessionMock.error = ErrorMock.mockCase
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .other)
    }
    
    func testNetworkHelper_whenErrorNil_loginFailWithErrorCodeNil() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = nil
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(nil))
    }
    
    func testNetworkHelper_whenErrorNil_loginFailWithErrorCode() {
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(withUser: "", andPassword: "") { _, networkError in
            error = networkError
        }
        
        //Then
        XCTAssertEqual(error, .errorCode(404))
    }
    
    func testNetworkHelper_whenTokenReceived_loginSuccess() {
        var error: NetworkError?
        var retrievedToken: String?
        
        //Given
        urlSessionMock.error = nil
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(withUser: "", andPassword: "") { token, networkError in
            retrievedToken = token
            error = networkError
        }
        
        //Then
        XCTAssertEqual(retrievedToken, "TokenString", "should have received a token")
        XCTAssertNil(error, "there should be no error")
    }
    
    func testNetworkHelper_whenFetchHeroesJson_fetchSuccess() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getDataFrom(resourceName: "heroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "should be the same hero as in the json file")
        XCTAssertNil(error, "there should be no error")
        coreDataManager.deleteCoreData(element: "Hero")
    }
    
    func testNetworkHelper_whenFetchEmptyHeroesJson_fetchSuccess() {
        var error: NetworkError?
        var retrievedHeroes: [Hero]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getDataFrom(resourceName: "noData")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getHeroes { heroes, networkError in
            error = networkError
            retrievedHeroes = heroes
        }
        
        //Then
        XCTAssertNotNil(retrievedHeroes)
        XCTAssertEqual(retrievedHeroes?.count, 0)
        XCTAssertNil(error, "there should be no error")
    }
    
    func testNetworkHelper_whenFetchLocationsJson_fetchSuccess() {
        var error: NetworkError?
        var retrievedLocations: [Location]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getDataFrom(resourceName: "locations")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getLocations(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { locations, networkError in
            error = networkError
            retrievedLocations = locations
        }
        
        //Then
        XCTAssertEqual(retrievedLocations?.first?.id, "locationID", "should be the same location as in the json file")
        XCTAssertNil(error, "there should be no error")
        coreDataManager.deleteCoreData(element: "Location")

    }
    
    func testNetworkHelper_whenFetchEmptyLocationsJson_fetchSuccess() {
        var error: NetworkError?
        var retrievedLocations: [Location]?
        
        //Given
        sut.token = "testToken"
        urlSessionMock.data = getDataFrom(resourceName: "noData")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.getLocations(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94") { locations, networkError in
            error = networkError
            retrievedLocations = locations
        }
        
        //Then
        XCTAssertNotNil(retrievedLocations)
        XCTAssertEqual(retrievedLocations?.count, 0)
        XCTAssertNil(error, "there should be no error")
    }
}

extension NetworkHelperTests {
    func getDataFrom(resourceName: String) -> Data? {
        let bundle = Bundle(for: NetworkHelperTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}


