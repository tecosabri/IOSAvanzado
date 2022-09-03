//
//  LocalDataModel.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 12/7/22.
//

import Foundation


private enum Key {
    static let token = "TokenKey"
}

final class LocalDataModel {
    
    private static let userDefaults = UserDefaults.standard
    
    static func getToken() -> String? {
        return userDefaults.string(forKey: Key.token)
    }
    
    static func save(token: String) {
        userDefaults.set(token, forKey: Key.token)
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: Key.token)
    }
}
