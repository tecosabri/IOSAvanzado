//
//  CodingUserInfoKeyExtension.swift
//  CodableCoreDataEntitiesSample
//
//  Created by Ismael Sabri Pérez on 16/9/22.
//

import Foundation

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
