//
//  LocalizationModel.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 11/9/22.
//

import Foundation
import CoreData


public struct HeroId: Codable {
    let id: String
}

public class Location: NSManagedObject, Codable {
    
    // MARK: - Entity properties
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var dateShow: String?
    @NSManaged public var id: String?
    @NSManaged public var hero: Hero?
    @NSManaged var heroId: String? // This variable is going to store the encoded hero id
    
    enum CodingKeys: CodingKey {
        case latitud, longitud, dateShow, id, hero
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext)
        else {
            fatalError("Failed to decode location")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.dateShow = try container.decodeIfPresent(String.self, forKey: .dateShow)
            self.longitude = try container.decodeIfPresent(String.self, forKey: .longitud)
            self.latitude = try container.decodeIfPresent(String.self, forKey: .latitud)
            guard let heroId: HeroId = try container.decodeIfPresent(HeroId.self, forKey: .hero) else {return}
            self.heroId = heroId.id
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(latitude, forKey: .latitud)
        try container.encode(longitude, forKey: .longitud)
        try container.encode(dateShow, forKey: .dateShow)
        try container.encode(heroId, forKey: .hero)
    }
}

extension Location : Identifiable {

}


