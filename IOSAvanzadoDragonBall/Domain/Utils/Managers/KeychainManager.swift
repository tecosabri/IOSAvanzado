//
//  KeyChainManager.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 3/9/22.
//

import Foundation


class KeychainManager {
    
    enum KeychainError: Error {
        case duplicatedEntry
        case unknown(OSStatus)
    }
    
    static func save(
        password: String,
        forAccount account: String,
        andService service: String = "DragonBallMap") throws {
            
            // Convert password to data as it is required by apple's implementation
            guard let password = password.data(using: .utf8) else {
                print("Error while saving the password into keychain: unable to convert password into data")
                return
            }
            // Create query to save the password into Keychain
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecValueData as String: password as AnyObject
            ]
            
            
            // Add the item and check the success of the operation
            let queryStatus = SecItemAdd(query as CFDictionary, nil)
            guard queryStatus != errSecDuplicateItem else {
                print("Error while saving the password into keychain: duplicated entry")
                throw KeychainError.duplicatedEntry
            }
            guard queryStatus == errSecSuccess else {
                print("Error while saving the password into keychain: unknown error")
                throw KeychainError.unknown(queryStatus)
            }
            print("Password saved into keychain succesfully")
        }
    
    static func getPassword(
        forAccount account: String,
        andService service: String = "DragonBallMap") throws -> String?{
            // Create query to get the password from Keychain
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecReturnData as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            // Get the item into result variable and check the success of the operation
            var result: AnyObject?
            let queryStatus = SecItemCopyMatching(query as CFDictionary, &result)
            
            guard queryStatus == errSecSuccess else {
                print("Error while retrieving the password from keychain: unknown error")
                throw KeychainError.unknown(queryStatus)
            }
            print("Password retrieved from keychain succesfully")
            
            guard let dataResult = result as? Data else {
                print("Error while retrieving the password from keychain: unable to convert bytearray password to data")
                return nil
            }
            let stringResult = String(decoding: dataResult, as: UTF8.self)
            
            return stringResult
        }
    
    static func deletePassword(
        forAccount account: String,
        andService service: String = "DragonBallMap") throws {
            
            // Create query to delete the password from Keychain
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject
            ]
            
            
            // Delete the password and check the success of the operation
            let queryStatus = SecItemDelete(query as CFDictionary)
            guard queryStatus == errSecSuccess else {
                print("Error while deleting the password from keychain: unknown error")
                throw KeychainError.unknown(queryStatus)
            }
            print("Password deleted from keychain succesfully")
        }
}
