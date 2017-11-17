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
import Kanna
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
    
    public func saveContext() {
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
    
    // MARK: Reload
    
    public func updateDatabaseIfNeeded(forced: Bool = false) -> Promise<Void> {
        // do we need to update?
        if !forced && !needsDatabaseUpdate && getRestaurants().count > 0 {
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

    // MARK: Fetch Helpers
    
    private func safeFetch<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try viewContext.fetch(fetchRequest)
        }
        catch let e {
            debugPrint("Fetch request failed: \((e as NSError).localizedDescription)")
            return [T]()
        }
    }

    public func getRestaurants() -> [Restaurant] {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        return safeFetch(fetchRequest)
    }

    public func getHoraires() -> [Horaire] {
        let fetchRequest: NSFetchRequest<Horaire> = NSFetchRequest(entityName: "Horaire")
        return safeFetch(fetchRequest)
    }

    public func getRestaurant(identifier: Int) -> Restaurant? {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", String(identifier))
        return safeFetch(fetchRequest).first
    }

    public func getHoraire(restaurant: Restaurant) -> Horaire? {
        let fetchRequest: NSFetchRequest<Horaire> = NSFetchRequest(entityName: "Horaire")
        fetchRequest.predicate = NSPredicate(format: "idResto == %@", String(restaurant.identifier?.intValue ?? -1))
        return safeFetch(fetchRequest).first
    }
}

internal func cleanHTMLString(str: String) -> String {
    // decode basic entities
    var strResult = str
    strResult = strResult.replacingOccurrences(of: "<br />", with: "")
    strResult = strResult.replacingOccurrences(of:"<p>", with: "")
    strResult = strResult.replacingOccurrences(of:"</p>", with: "")
    strResult = strResult.replacingOccurrences(of:"&#039;", with: "'")
    strResult = strResult.replacingOccurrences(of:"&rsquo;", with: "'")
    strResult = strResult.replacingOccurrences(of:"&#8211;", with: "–")
    strResult = strResult.replacingOccurrences(of:"&#8211;", with: "–")
    strResult = strResult.replacingOccurrences(of:"&amp;#038;", with: "&")
    strResult = strResult.replacingOccurrences(of:"&#038;", with: "&")

    // decode left entities
    let options: [String: Any] = [
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
    ]
    if let data = strResult.data(using: .utf8), let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
        strResult = attributedString.string
    }

    return strResult
}
