//
//  UserData.swift
//  VegoResto
//
//  Created by Laurent Nicolason 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//


import UIKit
import CoreData
import CoreLocation
import Alamofire
import GZIP
import SWXMLHash

class UserData: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = UserData()

    private var locationmanager: CLLocationManager?

    var location: CLLocationCoordinate2D? = nil

    // swiftlint:disable:next force_cast
    var managedContext = ( UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext


    private override init() {

        super.init()



        self.locationmanager = CLLocationManager()
        //locationmanager?.startUpdatingLocation()
        //locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.startUpdatingLocation()
        self.locationmanager?.delegate = self


    }

    func getRestaurants() -> [Restaurant] {

        let fetchRequest = NSFetchRequest(entityName: "Restaurant")

        do {

            let results = try self.managedContext.executeFetchRequest(fetchRequest)

            if let resultats_restaurants = (results as? [Restaurant]) {
                return resultats_restaurants
            } else {
                return [Restaurant]()
            }

        } catch _ {

            return [Restaurant]()

        }

    }



    func chargerDonneesLocales() {

        if let path = NSBundle.mainBundle().pathForResource("restaurants", ofType: "xml") {


            if let fileContents: NSData = NSData(contentsOfFile: path) {

                if let xml = String(data: fileContents, encoding: NSUTF8StringEncoding) {

                    self.parseXML(xml)
                }
            }

        }

    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        self.location = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)


    }


    func parseXML(xml: String) {


        let xml = SWXMLHash.parse(xml)

        var i = 0

        let entityRestaurant =  NSEntityDescription.entityForName("Restaurant", inManagedObjectContext:self.managedContext)


        for elem in xml["root"]["item"] {

            // récupération des éléments dans le XML)

            let name = elem["titre"].element?.text
            let adress = elem["adresse"].element?.text
            let latitude = elem["lat"].element?.text
            let longitude = elem["lon"].element?.text
            let website = elem["site_internet"].element?.text
            let phone = elem["tel_fixe"].element?.text
            let link = elem["link"].element?.text
            let identifer = elem["id"].element?.text



            var restaurant: Restaurant? = nil

            // si le restaurant existe déjà je le charge dans l'objet courrant
            if let _identifer = identifer {

                if let _identifier_to_int = Int(_identifer) {

                    restaurant = self.getRestaurantWithIdentifier( _identifier_to_int )
                }

            }

            //si il est nil je crée un objet dans mon contexte
            if restaurant == nil {

                restaurant = NSManagedObject(entity: entityRestaurant!, insertIntoManagedObjectContext: self.managedContext) as? Restaurant

            }

            // remplisssage de l'objet (ou mise à jour)
            if let _name = name {
                restaurant?.name = self.cleanString(_name)
            }

            if let _adress = adress {
                restaurant?.address = self.cleanString(_adress)
            }

            restaurant?.website = website
            restaurant?.absolute_url = link
            restaurant?.phone = phone

            if let _identifer = identifer {
                restaurant?.identifier = Int(_identifer)
            }

            if let _latitude = latitude {
                restaurant?.lat = Double(_latitude)
            }

            if let _longitude = longitude {
                restaurant?.lon = Double(_longitude)
            }

            restaurant?.tags = NSSet()




            i += 1
        }

        Debug.log("Parser XML : \(i) element(s)")

        do {
            try self.managedContext.save()
        } catch _ {
            Debug.log("erreur save managedContext")
        }
    }



    func cleanString(str: String) -> String {

        var strResult = str.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
        strResult = strResult.stringByReplacingOccurrencesOfString("&#039;", withString: "'")

        return strResult
    }




    func getRestaurantWithIdentifier(identifier: Int) -> Restaurant? {

        /*

         NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"attribute = %@", searchingFor];
         NSError *error = nil;
         NSArray *results = [context executeFetchRequest:request error:&amp;error];
         */

        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Restaurant")
        let predicate: NSPredicate = NSPredicate(format: "identifier = %@", String(identifier) )
        fetchRequest.predicate = predicate

        do {

            let results = try self.managedContext.executeFetchRequest(fetchRequest)

            if let resultats_restaurants = (results as? [Restaurant]) {

                if resultats_restaurants.count > 0 {

                    return resultats_restaurants[0]
                }
            }

        } catch _ {


        }


        return nil
    }

    func loadDataOnVegorestoURL() {

        Alamofire.request(.GET, "http://vegoresto.fr/restos-fichier-xml/", parameters: nil)
            .responseData { ( response ) in

                //Debug.log(response.request)  // original URL request
                //Debug.log(response.response) // URL response

                Debug.log("Téléchargement page : http://vegoresto.fr/restos-fichier-xml/")

                switch response.result {
                case .Success:
                    Debug.log("Validation Successful")
                case .Failure(let error):
                    Debug.log(error)
                }


                if let decompressedData: NSData = response.data?.gunzippedData() {

                    if let decompressedXML: String = String(data: decompressedData, encoding: NSUTF8StringEncoding) {

                        Debug.log("Decompression XML : OK")

                        self.parseXML(decompressedXML)

                    }
                }

        }


    }


}
