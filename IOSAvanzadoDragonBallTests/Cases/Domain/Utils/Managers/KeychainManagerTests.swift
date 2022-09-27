//
//  KeychainManagerTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class KeychainManagerTests: XCTestCase {

    let account = "MockService"
    let password = "MockPassword"
    
    override func setUp() async throws {
        try KeychainManager.save(password: password, forAccount: account)
    }

    override func tearDown() async throws {
        try KeychainManager.deletePassword(forAccount: account)
    }
    
    func testKeychainManager_whenPasswordDuplicated_savePasswordThrowsDuplicatedEntryError() {
        // given saved password for account
        // when save another time password for same account
        // then
        XCTAssertThrowsError(try KeychainManager.save(password: password, forAccount: account))
    }
    
    func testKeychainManager_whenNoPasswordSaved_getPasswordThrowsUnknownError() {
        // given no password saved for account
        try! KeychainManager.deletePassword(forAccount: account)
        // when KeychainManager tries to get password for that account
        // then
        XCTAssertThrowsError(try KeychainManager.getPassword(forAccount: account))
        try! KeychainManager.save(password: password, forAccount: account)
    }
    
    func testKeychainManager_whenSavePasswordForAccount_retrievePasswordForAccountSuccessfully() {
        // given password saved for account
        // when KeychainManager tries to get password for that account
        // then
        XCTAssertNoThrow(try KeychainManager.getPassword(forAccount: account))
    }
    
    

}
