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
    var managedContext = ( UIApplication.shared.delegate as! AppDelegate ).managedObjectContext


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

        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")

        do {

            let results = try self.managedContext.fetch(fetchRequest )

            return results


        } catch _ {

            return [Restaurant]()

        }

    }



    func chargerDonnees() {


        self.loadDataOnVegorestoURL()

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



    func parseXML(xml: String) {

        var nbObjetCrées = 0

        self.managedContext.perform {

            let entityRestaurant =  NSEntityDescription.entity(forEntityName: "Restaurant", in: self.managedContext)
            let entityTag =  NSEntityDescription.entity(forEntityName: "Tag", in: self.managedContext)


            let xml = SWXMLHash.parse(xml)

            for elem in xml["root"]["item"] {

                // récupération des éléments dans le XML)


                var restaurant: Restaurant? = nil


                let identifer = elem["id"].element?.text


                // si le restaurant existe déjà je le charge dans l'objet courrant
                if let _identifer = identifer {

                    if let _identifier_to_int = Int(_identifer) {

                        restaurant = self.getRestaurantWithIdentifier( identifier: _identifier_to_int )
                    }

                }

                //si il est nil je crée un objet dans mon contexte
                if restaurant == nil {

                    restaurant = NSManagedObject(entity: entityRestaurant!, insertInto: self.managedContext) as? Restaurant

                }




                // remplisssage de l'objet (ou mise à jour)
                if let _name = elem["titre"].element?.text {
                    restaurant?.name = self.cleanString(str: _name)
                }

                if let _adress = elem["adresse"].element?.text {
                    restaurant?.address = self.cleanString(str: _adress)
                }


                if let _resume = elem["description"].element?.text?.html2String {
                    restaurant?.resume = self.cleanString(str: _resume)
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
                //restaurant?.fermeture = elem["fermeture"].element?.text
                restaurant?.image = elem["image"].element?.text

                var dicoDays = [ String : String ]()

                for elemHoraire in elem["horaires"]["h"] {

                    if let day_str = elemHoraire.element?.attribute(by: "day")?.text,
                        let start_str = elemHoraire.element?.attribute(by: "s")?.text,
                        let end_str = elemHoraire.element?.attribute(by: "e")?.text /*,
                         let text_str = elemHoraire.element?.text */{


                            if start_str.characters.count == 4 && end_str.characters.count == 4 {

                                var start_str_updated = start_str
                                start_str_updated.insert("h", at: start_str_updated.index(start_str_updated.startIndex, offsetBy: 2)  )

                                var end_str_updated = end_str
                                end_str_updated.insert("h", at: end_str_updated.index(end_str_updated.startIndex, offsetBy: 2)  )


                                var infoDay = "De " + start_str_updated + " à " + end_str_updated

                                if let previousInfoDay = dicoDays[day_str] {

                                    infoDay = previousInfoDay + " & " + infoDay

                                }

                                dicoDays[day_str] = infoDay

                            }

                    }
                }


                restaurant?.h_lundi = dicoDays["lundi"]
                restaurant?.h_mardi = dicoDays["mardi"]
                restaurant?.h_mercredi = dicoDays["mercredi"]
                restaurant?.h_jeudi = dicoDays["jeudi"]
                restaurant?.h_vendredi = dicoDays["vendredi"]
                restaurant?.h_samedi = dicoDays["samedi"]
                restaurant?.h_dimanche = dicoDays["dimanche"]


                restaurant?.mail = elem["mel_public"].element?.text


                restaurant?.animaux_bienvenus =   NSNumber(value:  ( (elem["animaux_bienvenus"].element?.text) == "oui")   )
                restaurant?.terrasse = NSNumber(value: ( (elem["terrasse"].element?.text) == "oui"))


                if let _identifer = identifer {
                    restaurant?.identifier = Int(_identifer) as NSNumber?
                }

                if let _latitude = elem["lat"].element?.text {
                    restaurant?.lat = Double(_latitude) as NSNumber?
                }

                if let _longitude = elem["lon"].element?.text {
                    restaurant?.lon = Double(_longitude) as NSNumber?
                }

                restaurant?.tags = NSSet()

                if let categories_culinaires = elem["categories_culinaires"].element?.text {

                    let arrayOfTags = categories_culinaires.components(separatedBy: "|")

                    for strTag in arrayOfTags {

                        if let new_tag = (NSManagedObject(entity: entityTag!, insertInto: self.managedContext) as? Tag) {

                            new_tag.name = strTag
                            new_tag.restaurants = NSSet()

                            restaurant?.addTag(tag: new_tag)
                        }
                    }
                }

                nbObjetCrées = nbObjetCrées + 1
            }

            Debug.log(object: "Parser XML : \(nbObjetCrées) element(s)")


            do {
                try self.managedContext.save()
            } catch _ {
                Debug.log(object: "erreur save managedContext")
            }



            if nbObjetCrées == 0 && self.getRestaurants().count == 0 {

                SwiftSpinner.show("Chargement des données...")

                if let path = Bundle.main.path(forResource: "restaurants", ofType: "xml") {

                    if let fileContents: NSData = NSData(contentsOfFile: path) {

                        if let xml = String(data: fileContents as Data, encoding: String.Encoding.utf8) {

                            SwiftSpinner.show("Chargement des données...")


                            self.parseXML(xml: xml)
                        }
                    }

                }

            } else {

                SwiftSpinner.hide()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHARGEMENT_TERMINE"), object: nil)

                Debug.log(object: "fin chargement des données depuis URL")

            }

        }

    }


    func cleanString(str: String) -> String {

        var strResult = str.replacingOccurrences(of: "<br />", with: "\n")

        strResult = strResult.replacingOccurrences(of:"<p>", with: "")
        strResult = strResult.replacingOccurrences(of:"</p>", with: "")
        strResult = strResult.replacingOccurrences(of:"&#039;", with: "'")
        strResult = strResult.replacingOccurrences(of:"&rsquo;", with: "'")
        strResult = strResult.replacingOccurrences(of:"&#8211;", with: "–")
        strResult = strResult.replacingOccurrences(of:"&amp;#038;", with: "&")

        return strResult
    }


    func getRestaurantWithIdentifier(identifier: Int) -> Restaurant? {


        let fetchRequest: NSFetchRequest<Restaurant> = NSFetchRequest(entityName: "Restaurant")
        let predicate: NSPredicate = NSPredicate(format: "identifier = %@", String(identifier) )
        fetchRequest.predicate = predicate

        do {

            let results = try self.managedContext.fetch(fetchRequest)

            if results.count > 0 {

                return results[0]
            }

        } catch _ {

        }

        return nil

    }


    func loadDataOnVegorestoURL() {

        Alamofire.request("http://vegoresto.fr/restos-fichier-xml/").responseData { (response) in

            Debug.log(object: "Téléchargement page : http://vegoresto.fr/restos-fichier-xml/")

            switch response.result {
            case .success:
                Debug.log(object: "Validation Successful")
            case .failure(let error):
                Debug.log(object: error)
            }




            if let dataCompressed = response.data {


                if let decompressedData = NSData(data: dataCompressed).gunzipped() {


                    if let decompressedXML: String = String(data: decompressedData as Data, encoding: String.Encoding.utf8) {

                        Debug.log(object: "Decompression XML : OK")

                        SwiftSpinner.show("Chargement des données...")

                        self.parseXML(xml: decompressedXML)

                    }

                }

            }
        }
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

}
