//
//  RegexHelperTests.swift
//  IOSAvanzadoDragonBallTests
//
//  Created by Ismael Sabri Pérez on 24/9/22.
//

import XCTest
@testable import IOSAvanzadoDragonBall

final class RegexHelperTests: XCTestCase {
    
    var recipientName: String!
    var domainName: String!
    var topLevelDomain: String!
   
    func testRegexHelper_whenNoRecipientName_regexNotMatching() {
        // given
        recipientName = ""
        domainName = "gmail"
        topLevelDomain = ".com"
        let userMail = recipientName + domainName + topLevelDomain
        // when mail regex tries to match usermail
        // then
        XCTAssertNil(userMail.wholeMatch(of: RegexHelper.getMailRegex()))
    }
    
    func testRegexHelper_whenNoDomainName_regexNotMatching() {
        // given
        recipientName = "hisme14@"
        domainName = ""
        topLevelDomain = ".com"
        let userMail = recipientName + domainName + topLevelDomain
        // when mail regex tries to match usermail
        // then
        XCTAssertNil(userMail.wholeMatch(of: RegexHelper.getMailRegex()))
    }
    
    func testRegexHelper_whenNoTopLevelDomain_regexNotMatching() {
        // given
        recipientName = "hisme14@"
        domainName = ""
        topLevelDomain = ""
        let userMail = recipientName + domainName + topLevelDomain
        // when mail regex tries to match usermail
        // then
        XCTAssertNil(userMail.wholeMatch(of: RegexHelper.getMailRegex()))
    }
    
    func testRegexHelper_whenValidUserMail_regexMatching() {
        // given
        recipientName = "hisme14@"
        domainName = "gmail"
        topLevelDomain = ".com"
        let userMail = recipientName + domainName + topLevelDomain
        // when mail regex tries to match usermail
        // then
        XCTAssertNotNil(userMail.wholeMatch(of: RegexHelper.getMailRegex()))
    }

}
