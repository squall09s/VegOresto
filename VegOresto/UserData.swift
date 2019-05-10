//
//  UserData.swift
//  VegOresto
//
//  Created by Laurent Nicolason 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import SwiftSpinner
import UIKit
import CoreData
import Alamofire
import PromiseKit

class UserData {

    static let shared = UserData()

    // MARK: Core Data
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VegOresto", managedObjectModel: self.managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error creating persistent store container \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "VegOresto", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveViewContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        return persistentContainer.performBackgroundTask(block)
    }
    
    public func performBackgroundMapping<T>(_ block: @escaping (NSManagedObjectContext) throws -> T, autosave: Bool = false) -> Promise<T> {
        return Promise(resolvers: { (fulfill, reject) in
            self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) in
                do {
                    let result = try block(context)
                    if autosave {
                        try context.save()
                    }
                    fulfill(result)
                } catch let e {
                    reject(e)
                }
            })
        })
    }
    
    public func backgroundFlatMap<T, U: NSManagedObject>(_ mapArray: [T], block: @escaping (NSManagedObjectContext, T) throws -> U?, diffEntityName: String, diffPredicate: NSPredicate? = nil, autosave: Bool = false) -> Promise<[U]> {
        return Promise(resolvers: { (fulfill, reject) in
            self.persistentContainer.performBackgroundTask({ (context: NSManagedObjectContext) in
                // fetch object IDs before mapping
                let originalObjectIDs = context.fetchObjectIDs(entityName: diffEntityName, predicate: diffPredicate)
                let originalObjectIDSet = Set(originalObjectIDs.map({ (objectID: NSManagedObjectID) -> String in
                    return objectID.uriRepresentation().absoluteString
                }))

                // perform mapping
                var result: [U]
                do {
                    result = try mapArray.flatMap({ (item: T) throws -> U? in
                        return try block(context, item)
                    })
                } catch let e {
                    reject(e)
                    return
                }

                // get new object IDs
                let finalObjectIDSet = Set(result.map({ (item: NSManagedObject) -> String in
                    return item.objectID.uriRepresentation().absoluteString
                }))

                // objects to delete
                var toDeleteObjectIDSet = originalObjectIDSet
                toDeleteObjectIDSet.subtract(finalObjectIDSet)

                // delete extra objects
                for objectID in originalObjectIDs {
                    if toDeleteObjectIDSet.contains(objectID.uriRepresentation().absoluteString) {
                        let object = context.object(with: objectID)
                        context.delete(object)
                    }
                }

                // save
                do {
                    if autosave {
                        try context.save()
                    }
                    fulfill(result)
                } catch let e {
                    reject(e)
                }
            })
        })
    }
    
    // MARK: Reload
    
    public func updateDatabaseIfNeeded(forced: Bool = false) -> Promise<Void> {
        // should we skip update?
        if !forced && !needsDatabaseUpdate && viewContext.countRestaurants() > 0 {
            return Promise()
        }

        // update and save last sync date
        return WebRequestManager.shared.loadRestaurants().then(execute: { (_: [Restaurant]) -> Void in
            self.saveSynchroDate()
        }).asVoid()
    }

    private var needsDatabaseUpdate: Bool {
        if getLastUpdateData() < INTERVAL_REFRESH_DATA {
            return false
        } else {
            return true
        }
    }

    private func getLastUpdateData() -> Int {
        if let date = UserDefaults.standard.object(forKey: KEY_LAST_SYNCHRO) as? Date {
            return abs(Int(date.timeIntervalSinceNow))
        }
        return INTERVAL_REFRESH_DATA + 1

    }

    private func saveSynchroDate() {
        UserDefaults.standard.set( Date(), forKey: KEY_LAST_SYNCHRO)
    }
    
    // MARK: Date Formatting
    
    lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

// MARK: Fetch Helpers

extension NSManagedObjectContext {
    private func safeFetch<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try self.fetch(fetchRequest)
        }
        catch let e {
            debugPrint("Fetch request failed: \((e as NSError).localizedDescription)")
            return [T]()
        }
    }
    
    private func safeFetchIDs(_ fetchRequest: NSFetchRequest<NSManagedObjectID>) -> [NSManagedObjectID] {
        do {
            return try self.fetch(fetchRequest)
        }
        catch let e {
            debugPrint("Fetch request failed: \((e as NSError).localizedDescription)")
            return [NSManagedObjectID]()
        }
    }
    
    private func safeCount<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) -> Int {
        do {
            return try self.count(for: fetchRequest)
        }
        catch let e {
            debugPrint("Fetch request (count) failed: \((e as NSError).localizedDescription)")
            return (-1)
        }
    }
    
    internal func fetchObjects(entityName: String, predicate: NSPredicate? = nil) -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .managedObjectResultType
        return safeFetch(fetchRequest)
    }
    
    internal func fetchObjectIDs(entityName: String, predicate: NSPredicate? = nil) -> [NSManagedObjectID] {
        let fetchRequest: NSFetchRequest<NSManagedObjectID> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .managedObjectIDResultType
        return safeFetchIDs(fetchRequest)
    }
    
    internal func getRestaurants() -> [Restaurant] {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        return safeFetch(fetchRequest)
    }
    
    internal func countRestaurants() -> Int {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        return safeCount(fetchRequest)
    }
    
    internal func getHoraires() -> [Horaire] {
        let fetchRequest: NSFetchRequest<Horaire> = NSFetchRequest(entityName: "Horaire")
        return safeFetch(fetchRequest)
    }
    
    internal func getRestaurant(identifier: Int) -> Restaurant? {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", String(identifier))
        return safeFetch(fetchRequest).first
    }
    
    internal func getHoraire(restaurantId: Int) -> Horaire? {
        let fetchRequest: NSFetchRequest<Horaire> = NSFetchRequest(entityName: "Horaire")
        fetchRequest.predicate = NSPredicate(format: "idResto == %@", String(restaurantId))
        return safeFetch(fetchRequest).first
    }
    
    internal func getHoraire(restaurant: Restaurant) -> Horaire? {
        guard let restaurantId = restaurant.identifier?.intValue else {
            return nil
        }
        return getHoraire(restaurantId: restaurantId)
    }
    
    internal func getComment(identifier: Int) -> Comment? {
        let fetchRequest: NSFetchRequest<Comment> = NSFetchRequest(entityName: "Comment")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", String(identifier))
        return safeFetch(fetchRequest).first
    }
    
    internal func getCategorieCulinaire(name: String) -> CategorieCulinaire? {
        let fetchRequest: NSFetchRequest<CategorieCulinaire> = NSFetchRequest(entityName: "CategorieCulinaire")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        return safeFetch(fetchRequest).first
    }
}
