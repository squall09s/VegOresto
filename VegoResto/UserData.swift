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

        // chargement des données depuis fichier local uniquement si la base de données CoreData est vide
        if self.getRestaurants().count == 0 {

            if let path = NSBundle.mainBundle().pathForResource("restaurants", ofType: "xml") {


                if let fileContents: NSData = NSData(contentsOfFile: path) {

                    if let xml = String(data: fileContents, encoding: NSUTF8StringEncoding) {

                        self.parseXML(xml)
                    }
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

        let entityTag =  NSEntityDescription.entityForName("Tag", inManagedObjectContext:managedContext)


        for elem in xml["root"]["item"] {

            // récupération des éléments dans le XML)

            let name = elem["titre"].element?.text
            let adress = elem["adresse"].element?.text
            let latitude = elem["lat"].element?.text
            let longitude = elem["lon"].element?.text
            let website = elem["site_internet"].element?.text
            let phone = elem["tel_fixe"].element?.text
            let link = elem["vgo_url"].element?.text
            let identifer = elem["id"].element?.text
            let ville = elem["ville"].element?.text
            let resume = elem["description"].element?.text
            let facebook = elem["facebook"].element?.text
            let type_etablissement = elem["type_etablissement"].element?.text
            let montant_moyen = elem["montant_moyen"].element?.text
            let terrasse = elem["terrasse"].element?.text
            let moyens_de_paiement = elem["moyens_de_paiement"].element?.text
            let langues_parlees = elem["langues_parlees"].element?.text
            let animaux_bienvenus = elem["animaux_bienvenus"].element?.text
            let influence_gastronomique = elem["influence_gastronomique"].element?.text
            let ambiance = elem["ambiance"].element?.text
            let fermeture = elem["fermeture"].element?.text
            let image = elem["image"].element?.text


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
            restaurant?.ville = ville
            restaurant?.resume = resume
            restaurant?.facebook = facebook
            restaurant?.type_etablissement = type_etablissement
            restaurant?.montant_moyen = montant_moyen
            restaurant?.moyens_de_paiement = moyens_de_paiement
            restaurant?.langues_parlees = langues_parlees
            restaurant?.influence_gastronomique = influence_gastronomique
            restaurant?.ambiance = ambiance
            restaurant?.fermeture = fermeture
            restaurant?.image = image


            if let _animaux_bienvenus = animaux_bienvenus {
                restaurant?.animaux_bienvenus = ( _animaux_bienvenus == "oui" )
            }

            if let _terrasse = terrasse {
                restaurant?.terrasse = ( _terrasse == "oui" )
            }

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


            if let categories_culinaires = elem["categories_culinaires"].element?.text {

                let arrayOfTags = categories_culinaires.componentsSeparatedByString("|")

                for strTag in arrayOfTags {

                    if let new_tag = (NSManagedObject(entity: entityTag!, insertIntoManagedObjectContext: managedContext) as? Tag) {

                        new_tag.name = strTag
                        new_tag.restaurants = NSSet()

                        restaurant?.addTag(new_tag)
                    }
                }
            }



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
        strResult = strResult.stringByReplacingOccurrencesOfString("&rsquo;", withString: "'")
        strResult = strResult.stringByReplacingOccurrencesOfString("&#8211;", withString: "–")


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
