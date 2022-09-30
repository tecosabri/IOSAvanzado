//
//  HeroTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class HeroTests: XCTestCase {
    
    var networkHelperTest: NetworkHelperTests!

    override func setUpWithError() throws {
        networkHelperTest = NetworkHelperTests()
    }
    
    override func tearDownWithError() throws {
        networkHelperTest = nil
    }
    
    func testLocation_whenInitFromWrongDecoder_throwsFatalError() {
        //Given
        guard let data = networkHelperTest.getDataFrom(resourceName: "heroes") else {return}
        let decoder = JSONDecoder()
        //When
        //Then
        XCTAssertThrowsError(try decoder.decode([Hero].self, from: data))
    }
}
