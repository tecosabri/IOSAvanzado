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
    
    func save() {
        let context = container.viewContext
        do {
            try context.save()
        } catch {
            print("Error while saving context")
        }
    }
    
    func fetchObjects<T: NSManagedObject>(withPredicate predicate: NSPredicate? = nil) -> [T]{
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            fatalError("Error while creating the fetch request for \(T.self)")
        }
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
