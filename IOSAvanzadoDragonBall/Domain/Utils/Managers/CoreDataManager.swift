//
//  CoreDataManager.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 9/9/22.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    private let container: NSPersistentContainer
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
//        configureCoreData()
    }
    
    private func configureCoreData() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    func create(hero: Hero, completion: (() -> Void)? = nil) {
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
    }
    
    func fetchHeros(withPredicate predicate: NSPredicate? = nil) -> [Heroe] {
        let fetchRequest: NSFetchRequest<Heroe> = Heroe.fetchRequest()
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error while fetching ")
        }
        return []
    }
    
    func deleteCoreData(heroe: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: heroe)
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
