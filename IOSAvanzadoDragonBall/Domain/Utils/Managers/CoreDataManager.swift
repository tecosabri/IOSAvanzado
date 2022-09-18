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
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Add to avoid duplicate entries when coredata saving by id on locations and heroes
    }
    
    func save() {
        let context = container.viewContext
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error{
            print("Error while saving context: \(error.localizedDescription)")
        }
    }
    
    func fetchObjects<T: NSManagedObject>(withEntityType type: T.Type, withPredicate predicate: NSPredicate? = nil) -> [T] {
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type.self))
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        guard let result = try? container.viewContext.fetch(fetchRequest) else {
            print("Error while fetching heroes")
            return []
        }
        
        return result
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
                    print("Deleted element from \(element) entity")
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}
