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



    func chargerDonnees() {


        self.loadDataOnVegorestoURL()

    }




    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        self.locationmanager?.stopUpdatingLocation()

        Debug.log(error)

    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {

            self.location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false

        switch status {
        case CLAuthorizationStatus.Restricted:
            Debug.log( "Restricted Access to location")
        case CLAuthorizationStatus.Denied:
            Debug.log( "User denied access to location")
        case CLAuthorizationStatus.NotDetermined:
            Debug.log( "Status not determined")
        default:
            Debug.log( "Allowed to location Access")
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)

        if shouldIAllow == true {
            Debug.log("Location to Allowed")

            self.locationmanager?.startUpdatingLocation()
        }
    }



    func parseXML(xml: String) {

        var nbObjetCrées = 0

        self.managedContext.performBlock {

            let entityRestaurant =  NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: self.managedContext)
            let entityTag =  NSEntityDescription.entityForName("Tag", inManagedObjectContext: self.managedContext)


            let xml = SWXMLHash.parse(xml)

            for elem in xml["root"]["item"] {

                // récupération des éléments dans le XML)


                var restaurant: Restaurant? = nil


                let identifer = elem["id"].element?.text


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
                if let _name = elem["titre"].element?.text {
                    restaurant?.name = self.cleanString(_name)
                }

                if let _adress = elem["adresse"].element?.text {
                    restaurant?.address = self.cleanString(_adress)
                }

                if let _resume = elem["description"].element?.text?.html2String {
                    restaurant?.resume = self.cleanString(_resume)
                }

                restaurant?.website = elem["site_internet"].element?.text
                restaurant?.absolute_url = elem["vgo_url"].element?.text
                restaurant?.phone =  elem["tel_fixe"].element?.text
                restaurant?.ville = elem["ville"].element?.text
                restaurant?.facebook = elem["facebook"].element?.text
                restaurant?.type_etablissement = elem["type_etablissement"].element?.text
                restaurant?.montant_moyen = elem["montant_moyen"].element?.text
                restaurant?.moyens_de_paiement = elem["moyens_de_paiement"].element?.text
                restaurant?.influence_gastronomique = elem["influence_gastronomique"].element?.text
                restaurant?.ambiance = elem["ambiance"].element?.text
                restaurant?.fermeture = elem["fermeture"].element?.text
                restaurant?.image = elem["image"].element?.text

                restaurant?.h_lundi = elem["lundi"].element?.text
                restaurant?.h_mardi = elem["mardi"].element?.text
                restaurant?.h_mercredi = elem["mercredi"].element?.text
                restaurant?.h_jeudi = elem["jeudi"].element?.text
                restaurant?.h_vendredi = elem["vendredi"].element?.text
                restaurant?.h_samedi = elem["samedi"].element?.text
                restaurant?.h_dimanche = elem["dimanche"].element?.text

                restaurant?.h_matin = elem["horaires_matin"].element?.text
                restaurant?.h_midi = elem["horaires_midi"].element?.text
                restaurant?.h_ap_midi = elem["horaires_am"].element?.text
                restaurant?.h_soir = elem["horaires_soir"].element?.text
                restaurant?.h_nuit = elem["horaires_nuit"].element?.text
                restaurant?.mail = elem["mel_public"].element?.text


                restaurant?.animaux_bienvenus = ( (elem["animaux_bienvenus"].element?.text) == "oui")
                restaurant?.terrasse = ( (elem["terrasse"].element?.text) == "oui")


                if let _identifer = identifer {
                    restaurant?.identifier = Int(_identifer)
                }

                if let _latitude = elem["lat"].element?.text {
                    restaurant?.lat = Double(_latitude)
                }

                if let _longitude = elem["lon"].element?.text {
                    restaurant?.lon = Double(_longitude)
                }

                restaurant?.tags = NSSet()

                if let categories_culinaires = elem["categories_culinaires"].element?.text {

                    let arrayOfTags = categories_culinaires.componentsSeparatedByString("|")

                    for strTag in arrayOfTags {

                        if let new_tag = (NSManagedObject(entity: entityTag!, insertIntoManagedObjectContext: self.managedContext) as? Tag) {

                            new_tag.name = strTag
                            new_tag.restaurants = NSSet()

                            restaurant?.addTag(new_tag)
                        }
                    }
                }

                nbObjetCrées = nbObjetCrées + 1
            }

            Debug.log("Parser XML : \(nbObjetCrées) element(s)")


            do {
                try self.managedContext.save()
            } catch _ {
                Debug.log("erreur save managedContext")
            }



            if nbObjetCrées == 0 && self.getRestaurants().count == 0 {

                SwiftSpinner.show("Chargement des données...")

                if let path = NSBundle.mainBundle().pathForResource("restaurants", ofType: "xml") {

                    if let fileContents: NSData = NSData(contentsOfFile: path) {

                        if let xml = String(data: fileContents, encoding: NSUTF8StringEncoding) {

                            SwiftSpinner.show("Chargement des données...")

                            self.parseXML(xml)
                        }
                    }

                }


            } else {

                SwiftSpinner.hide()
                NSNotificationCenter.defaultCenter().postNotificationName("CHARGEMENT_TERMINE", object: nil)

                Debug.log("fin chargement des données depuis URL")

            }

        }



    }



    func cleanString(str: String) -> String {

        var strResult = str.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
        strResult = strResult.stringByReplacingOccurrencesOfString("<p>", withString: "")
        strResult = strResult.stringByReplacingOccurrencesOfString("</p>", withString: "")
        strResult = strResult.stringByReplacingOccurrencesOfString("&#039;", withString: "'")
        strResult = strResult.stringByReplacingOccurrencesOfString("&rsquo;", withString: "'")
        strResult = strResult.stringByReplacingOccurrencesOfString("&#8211;", withString: "–")
        strResult = strResult.stringByReplacingOccurrencesOfString("&amp;#038;", withString: "&")

        return strResult
    }







    func getRestaurantWithIdentifier(identifier: Int) -> Restaurant? {


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

                        SwiftSpinner.show("Chargement des données...")

                        self.parseXML(decompressedXML)

                    }
                }
        }
    }

}


extension String {

    var html2AttributedString: NSAttributedString? {
        guard
            let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return nil }
        do {
            let options: [String : AnyObject ] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding]
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch let error as NSError {
            Debug.log(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

}
