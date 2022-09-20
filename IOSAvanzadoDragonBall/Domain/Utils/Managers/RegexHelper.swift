//
//  RegexHelper.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 9/9/22.
//

import Foundation
import RegexBuilder

final class RegexHelper {
    
    static func getMailRegex() -> Regex<Substring> {
        // Create mail regex parts
        let recipientName = /^[A-Za-z0-9_\-!#$%&'*+\/=?^`{|]+/  // All possible characters before ampersand at least one time hisme14
        
        let domainName = /[A-Za-z0-9\-]+/
        let topLevelDomain = /\.[a-z]+$/
        // Create mail regex struct capturing the recipient and domain names
        let mailRegex = Regex {
            recipientName
            /@/
            domainName
            topLevelDomain
        }
        return mailRegex
    }
}
