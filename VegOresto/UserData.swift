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

    static let sharedInstance = UserData()

    //var allRestaurants: [Int : Restaurant] = [Int: Restaurant]()

    // swiftlint:disable:next force_cast
    var managedContext = ( UIApplication.shared.delegate as! AppDelegate ).managedObjectContext

    public func updateDatabaseIfNeeded(forced: Bool = false) -> Promise<Void> {
        // do we need to update?
        if !forced && !needsDatabaseUpdate && getRestaurants().count > 0 {
            return Promise()
        }

        // update and save last sync date
        return WebRequestManager.shared.listRestaurants().then(execute: { (_: [Restaurant]) -> Void in
            self.saveSynchroDate()
        }).asVoid()
    }

    private var needsDatabaseUpdate: Bool {
        if self.getLastUpdateData() < INTERVAL_REFRESH_DATA {
            return false
        } else {
            return true
        }
    }

    private func getLastUpdateData() -> Int {

        let defaults = UserDefaults.standard

        if let date = defaults.object(forKey: KEY_LAST_SYNCHRO) as? Date {

            return abs(Int(date.timeIntervalSinceNow))

        }

        return INTERVAL_REFRESH_DATA + 1

    }

    func saveSynchroDate() {
        let defaults = UserDefaults.standard
        defaults.set( Date(), forKey: KEY_LAST_SYNCHRO)
    }

    private func safeFetch<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try self.managedContext.fetch(fetchRequest)
        }
        catch let e {
            debugPrint("Fetch request failed: \((e as NSError).localizedDescription)")
            return [T]()
        }
    }

    func getRestaurants() -> [Restaurant] {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        return safeFetch(fetchRequest)
    }

    func getHoraires() -> [Horaire] {
        let fetchRequest: NSFetchRequest<Horaire> = NSFetchRequest(entityName: "Horaire")
        return safeFetch(fetchRequest)
    }

    func getCommentWithIdentifier(identifier: Int) -> Comment? {

        //print("getCommentWithIdentifier \(identifier)")
        let fetchRequest: NSFetchRequest<Comment> = NSFetchRequest(entityName: "Comment")
        let predicate: NSPredicate = NSPredicate(format: "ident == %@", String(identifier) )
        fetchRequest.predicate = predicate

        do {

            let results = try self.managedContext.fetch(fetchRequest)

            if results.count > 0 {

                //print("already exist")
                return results[0]
            }

        } catch _ {

        }
        //print("Comment not found")
        return nil

    }

    func getRestaurant(identifier: Int) -> Restaurant? {
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", String(identifier))
        return safeFetch(fetchRequest).first
    }

    func getHoraires(for restaurant: Restaurant) -> Horaire? {

        if let identifier: Int = restaurant.identifier?.intValue {

            for horaire in self.getHoraires() {

                if (horaire.idResto?.intValue ?? -1) == identifier {

                    return horaire

                }

            }

        }

        //print("horaire not found")
        return nil

    }

}

extension String {

    var html2AttributedString: NSAttributedString? {

        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {

            let attributedOptions: [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
                NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject
            ]

            return try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
        } catch let error as NSError {
            Debug.log(object: error.localizedDescription)
            return  nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    func countInstances(of stringToFind: String) -> Int {
        var stringToSearch = self
        var count = 0
        repeat {
            guard let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive)
                else { break }
            stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
            count += 1

        } while (true)

        return count
    }

}

func cleanHTMLString(str: String) -> String {
    var strResult = str.replacingOccurrences(of: "<br />", with: "")
    strResult = strResult.replacingOccurrences(of:"<p>", with: "")
    strResult = strResult.replacingOccurrences(of:"</p>", with: "")
    strResult = strResult.replacingOccurrences(of:"&#039;", with: "'")
    strResult = strResult.replacingOccurrences(of:"&rsquo;", with: "'")
    strResult = strResult.replacingOccurrences(of:"&#8211;", with: "–")
    strResult = strResult.replacingOccurrences(of:"&#8211;", with: "–")
    strResult = strResult.replacingOccurrences(of:"&amp;#038;", with: "&")
    strResult = strResult.replacingOccurrences(of:"&#038;", with: "&")
    return strResult
}
