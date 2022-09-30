//
//  HeroModel.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 10/7/22.
//

import Foundation
import CoreData


public class Hero: NSManagedObject, Decodable {
    
    // MARK: - Entity properties
    @NSManaged var name: String?
    @NSManaged var photo: String?
    @NSManaged public var id: String?
    @NSManaged var descript: String? // Not description as its a conflictive name
    @NSManaged public var locations: NSSet?
    @NSManaged var favorite: NSNumber?
    // Entities don't have booleans but NSNumbers 0 and 1, so it has to be converted to Bool the following way. Uncomment to get access to favorite
//    var isFavorite: Bool? {
//        get {
//            guard let favorite = favorite else {return nil}
//            return Bool(truncating: favorite)
//        }
//        set {
//            guard let newValue = newValue else {return}
//            favorite = NSNumber(value: newValue)
//        }
//    }
    
    enum CodingKeys: CodingKey {
        case name, photo, id, description, favorite
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Hero", in: managedObjectContext)
        else {
            throw DecodingError.decodingError
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite) as NSNumber?
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.descript = try container.decodeIfPresent(String.self, forKey: .description)
            self.photo = try container.decodeIfPresent(String.self, forKey: .photo)
        } catch {
            throw DecodingError.decodingError
        }
    }
    
    // Uncomment and set class de Codable to make Hero Encodable + Decodable
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(favorite as? Bool, forKey: .favorite)
//        try container.encode(name, forKey: .name)
//        try container.encode(descript, forKey: .description)
//        try container.encode(photo, forKey: .photo)
//    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }
}

extension Hero: Identifiable {

}
