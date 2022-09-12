//
//  CoreDataManager.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 9/9/22.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    let container: NSPersistentContainer
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
    }
    
    func create(hero: Hero, completion: (() -> Void)? = nil) -> Heroe {
        let context = container.viewContext
        
        let coreDataHero = Heroe(context: context)
        
        coreDataHero.id = hero.id
        coreDataHero.name = hero.name
        coreDataHero.photo = hero.photo.absoluteString
        coreDataHero.favorite = hero.favorite
        
        do {
            try context.save()
            print("\(hero.name) was saved successfully into core data")
        } catch {
            print("Error while saving \(hero.name)")
        }
        
        return coreDataHero
    }
    
    func fetchHeros(withPredicate predicate: NSPredicate? = nil) -> [Heroe]{
        let fetchRequest: NSFetchRequest<Heroe> = Heroe.fetchRequest()
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error while fetching heroes")
        }
        return []
    }
    
    func create(location: Location, completion: (() -> Void)? = nil) -> CDLocation {
        let context = container.viewContext
        
        let coreDataLocation = CDLocation(context: context)
        
        coreDataLocation.id = location.id
        coreDataLocation.dateShow = location.dateShow
        coreDataLocation.heroId = location.hero.id
        coreDataLocation.longitud = location.longitud
        coreDataLocation.latitud = location.latitud
        
        do {
            try context.save()
            print("Location \(location.id) was saved successfully into core data")
        } catch {
            print("Error while saving location \(location.id)")
        }
        
        return coreDataLocation
    }
    
    func fetchLocations(withPredicate predicate: NSPredicate? = nil) -> [CDLocation] {
        let fetchRequest: NSFetchRequest<CDLocation> = CDLocation.fetchRequest()
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error while fetching locations")
        }
        return []
    }
    
    func deleteCoreData(element: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: element)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}
