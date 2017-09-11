//
//  UserData.swift
//  VegoResto
//
//  Created by Laurent Nicolason 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import SwiftSpinner
import UIKit
import CoreData
import CoreLocation
import Alamofire
import GZIP
import SWXMLHash
import Kanna

class UserData: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = UserData()

    private var locationmanager: CLLocationManager?

    var location: CLLocationCoordinate2D?

    //var allRestaurants: [Int : Restaurant] = [Int: Restaurant]()

    // swiftlint:disable:next force_cast
    var managedContext = ( UIApplication.shared.delegate as! AppDelegate ).managedObjectContext

    private override init() {

        super.init()

        self.locationmanager = CLLocationManager()
        self.locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.startUpdatingLocation()
        self.locationmanager?.delegate = self

        /*
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")

        do {

            let results = try self.managedContext.fetch(fetchRequest)

            for resto: Restaurant in results {

                if let _ident = resto.identifier?.intValue {
                    self.allRestaurants[_ident] = resto
                }

            }

        } catch _ {

        }*/

    }

    func getLastUpdateData() -> Int {

        let defaults = UserDefaults.standard

        if let date = defaults.object(forKey: KEY_LAST_SYNCHRO) as? Date {

            return Int(date.timeIntervalSinceNow)

        }

        return INTERVAL_REFRESH_DATA + 1

    }

    func saveSynchroDate() {

        let defaults = UserDefaults.standard

        defaults.set( Date(), forKey: KEY_LAST_SYNCHRO)

    }

    func getRestaurants() -> [Restaurant] {

        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")

        do {

            let results = try self.managedContext.fetch(fetchRequest )

            return results

        } catch _ {

            return [Restaurant]()

        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        self.locationmanager?.stopUpdatingLocation()

        Debug.log(object: error)

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {

            self.location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        var shouldIAllow = false

        switch status {
        case CLAuthorizationStatus.restricted:
            Debug.log( object: "Restricted Access to location")
        case CLAuthorizationStatus.denied:
            Debug.log( object: "User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            Debug.log( object: "Status not determined")
        default:

            Debug.log( object: "Allowed to location Access")
            shouldIAllow = true
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)

        if shouldIAllow == true {

            Debug.log(object: "Location to Allowed")

            self.locationmanager?.startUpdatingLocation()
        }
    }

    
    func cleanString(str: String) -> String {

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

    func getRestaurantWithIdentifier(identifier: Int) -> Restaurant? {

        print("getRestaurantWithIdentifier \(identifier)")
        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        let predicate: NSPredicate = NSPredicate(format: "identifier = %@", String(identifier) )
        fetchRequest.predicate = predicate

        do {

            let results = try self.managedContext.fetch(fetchRequest)

            if results.count > 0 {

                print("already exist")
                return results[0]
            }

        } catch _ {

        }
        print("resto not found")
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
