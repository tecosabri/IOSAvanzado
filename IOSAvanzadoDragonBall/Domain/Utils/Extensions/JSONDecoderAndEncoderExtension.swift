//
//  JSONDecoderAndEncoderExtension.swift
//  CodableCoreDataEntitiesSample
//
//  Created by Ismael Sabri Pérez on 16/9/22.
//

import Foundation
import CoreData

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        guard let managedObjectContext = CodingUserInfoKey.managedObjectContext else {return}
        self.userInfo[managedObjectContext] = context
    }
}

extension JSONEncoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        guard let managedObjectContext = CodingUserInfoKey.managedObjectContext else {return}
        self.userInfo[managedObjectContext] = context
    }
}
