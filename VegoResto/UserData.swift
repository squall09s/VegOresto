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

    // swiftlint:disable:next force_cast
    var managedContext = ( UIApplication.shared.delegate as! AppDelegate ).managedObjectContext

    private override init() {

        super.init()

        self.locationmanager = CLLocationManager()
        self.locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.startUpdatingLocation()
        self.locationmanager?.delegate = self

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

    func parseXML(xml: String) {

        Debug.log(object: "Func[parseXML]")

        var nbObjetCrées = 0

        self.managedContext.perform {

            let entityRestaurant =  NSEntityDescription.entity(forEntityName: "Restaurant", in: self.managedContext)
            let entityCategorieCulinaire =  NSEntityDescription.entity(forEntityName: "CategorieCulinaire", in: self.managedContext)

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

                restaurant?.image = elem["image"].element?.text

                var dicoDays = [ String: String ]()

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

                restaurant?.categoriesCulinaire = NSSet()
                restaurant?.comments = NSSet()

                if let categories_culinaires = elem["categories_culinaires"].element?.text {

                    let arrayOfTags = categories_culinaires.components(separatedBy: "|")

                    for strTag in arrayOfTags {

                        if let new_cat = (NSManagedObject(entity: entityCategorieCulinaire!, insertInto: self.managedContext) as? CategorieCulinaire) {

                            new_cat.name = self.updateDataCategorieCulinaire(_cat:  strTag )
                            new_cat.restaurants = NSSet()

                            restaurant?.addCategorieCulinaire(newCategorie: new_cat)
                        }
                    }
                }

                if let _restaurant = restaurant {

                    self.updateDataMontantMoyen(resto: _restaurant)
                    self.updateDataTypeEtablissement(resto: _restaurant)
                    self.updateDataTypeAmbiance(resto: _restaurant)
                    self.updateDataInfluenceGastro(resto: _restaurant)
                    self.updateDataMoyensDePaiement(resto: _restaurant)

                }

                nbObjetCrées = nbObjetCrées + 1
            }

            Debug.log(object: "Parser XML : \(nbObjetCrées) element(s)")

            do {

                try self.managedContext.save()

            } catch _ {

                Debug.log(object: "erreur save managedContext")

            }

            //if nbObjetCrées == 0 && self.getRestaurants().count == 0 {

            //    self.loadLocalData()

            //} else {

                SwiftSpinner.hide()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHARGEMENT_TERMINE"), object: nil)

                Debug.log(object: "fin chargement des données depuis URL")

                self.saveSynchroDate()

            //}

        }

    }

    func loadLocalData() {

        SwiftSpinner.show("Chargement des données...")

        if let path = Bundle.main.path(forResource: "restaurants", ofType: "xml") {

            if let fileContents: NSData = NSData(contentsOfFile: path) {

                if let xml = String(data: fileContents as Data, encoding: String.Encoding.utf8) {

                    //SwiftSpinner.show("Chargement des données...")
                    self.parseXML(xml: xml)
                }
            }

        }

    }

    func updateDataCategorieCulinaire(_cat: String) -> String? {

        let dico : [ String : String ] = ["bio": "Bio",
                                          "brasserie": "Brasserie",
                                          "brunch": "Brunch",
                                          "bouchon": "Bouchon lyonnais",
                                          "bar_vin": "Bar à vin",
                                          "cru": "Cru",
                                          "glacier": "Glacier",
                                          "gastro": "Gastronomique",
                                          "local": "Local",
                                          "monde": "Cuisine du monde",
                                          "sans_gluten": "Sans gluten",
                                          "tapas": "Tapas",
                                          "tradi": "Traditionnel",
                                          "pizza": "Pizzeria",
                                          "vegan": "Végétalien, végane",
                                          "vege": "Végétarien",
                                          "pub": "Pub",
                                          "bistro": "Bistro",
                                          "crepe": "Crêperie",
                                          "moderne": "Moderne, créatif",
                                          "bar_jus": "Bar à jus",
                                          "tarte_vrai": "Tartes",
                                          "tarte": "Salades" ]

        if let val = dico[_cat] {

            return val

        } else {

            Debug.log(object: "ERROR - [updateDataCategorieCulinaire] key \(_cat) not found")
            return nil
        }
    }

    func updateDataMoyensDePaiement(resto: Restaurant) {

        let dico : [ String : String ] = ["cb": "Carte Bleue",
                                          "cheque": "Chèque",
                                          "espece": "Espèces",
                                          "ticket": "Ticket resto",
                                          "ae": "American Express",
                                          "vacances": "Chèque vacances"]

        var i = 0

        var resultat = ""

        if let _moyenPaiement = resto.moyens_de_paiement {

            if _moyenPaiement.characters.count > 0 {

                let moyensPaiement = _moyenPaiement.components(separatedBy: "|")

                for _key in moyensPaiement {

                    if let val = dico[_key] {

                        if i > 0 {

                            resultat = resultat + ", "
                        }

                        resultat = resultat + val

                        i = i + 1

                    } else {

                        Debug.log(object: "ERROR - [updateDataMoyensDePaiement] key \(_key) not found")
                    }
                }
            }
        }

        resto.moyens_de_paiement = resultat
    }

    func updateDataMontantMoyen(resto: Restaurant) {

        let dico : [ String : String ] = ["montant_8": "inférieur à 8€",
                                          "montant_15": "inférieur à 15€",
                                          "montant_1530": "15-30€",
                                          "montant_3060": "30-60€",
                                          "montant_60": "plus de 60€"]

        if let _key = resto.montant_moyen {

            if let val = dico[_key] {

                resto.montant_moyen = val

            } else {

                Debug.log(object: "ERROR - [updateDataMontantMoyen] key \(_key) not found")
            }

        }
    }

    func updateDataTypeEtablissement(resto: Restaurant) {

        let dico : [ String : String ] = ["vpc": "Restauration rapide, à emporter ou à domicile",
                                          "chambre": "Chambre d'hôtes",
                                          "resto": "Restaurant",
                                          "hotel": "Hôtel-restaurant"]

        if let _key = resto.type_etablissement {

            if let val = dico[_key] {

                resto.type_etablissement = val

            } else {

                Debug.log(object: "ERROR - [updateDataTypeEtablissement] key \(_key) not found")
            }

        }
    }

    func updateDataTypeAmbiance(resto: Restaurant) {

        let dico : [ String : String ] = ["branche": "Branché",
                                          "bistro": "Bistrot de caractère",
                                          "cosy": "Cosy",
                                          "spectacle": "Spectacle",
                                          "patrimoine": "Patrimoine",
                                          "vintage": "Vintage",
                                          "jardin": "Jardin",
                                          "hote": "Table d’hôte",
                                          "romantique": "Romantique",
                                          "dansant": "Dansant",
                                          "eau": "Au bord de l'eau"]
        var i = 0

        var resultat = ""

        if let _ambiance = resto.ambiance {

            if _ambiance.characters.count > 0 {

                let ambiances = _ambiance.components(separatedBy: "|")

                for _key in ambiances {

                    if let val = dico[_key] {

                        if i > 0 {

                            resultat = resultat + ", "
                        }

                        resultat = resultat + val

                        i = i + 1

                    } else {

                        Debug.log(object: "ERROR - [updateDataTypeAmbiance] key \(_key) not found")
                    }
                }
            }
        }

        resto.ambiance = resultat

    }

    func updateDataInfluenceGastro(resto: Restaurant) {

        let dico : [ String : String ] = ["francais_gastro": "Gastronomique français",
                                          "francais_region": "Régional français",
                                          "indien": "Indien",
                                          "italien": "Italien",
                                          "libanais": "Libanais",
                                          "marocain": "Marocain",
                                          "mexicain": "Mexicain",
                                          "turc": "Turc",
                                          "vietnamien": "Vietnamien",
                                          "thai": "Thailandais",
                                          "japonais": "Japonais",
                                          "autre": "Autre",
                                          "espagnol": "Espagnol",
                                          "tunisien": "Tunisien",
                                          "chinois": "Chinois",
                                          "coreen": "Coréen",
                                          "creole": "Créole"]

        var i = 0

        var resultat = ""

        if let _influence = resto.influence_gastronomique {

            if _influence.characters.count > 0 {

                let influences = _influence.components(separatedBy: "|")

                for _key in influences {

                    if let val = dico[_key] {

                        if i > 0 {

                            resultat = resultat + ", "
                        }

                        resultat = resultat + val

                        i = i + 1

                    } else {

                        Debug.log(object: "ERROR - [updateDataInfluenceGastro] key \(_key) not found")
                    }
                }
            }
        }

        resto.influence_gastronomique = resultat

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

        Debug.log(object: "Téléchargement page : https://vegoresto.fr/restos-fichier-xml/")

        Alamofire.request("https://vegoresto.fr/restos-fichier-xml/").responseData { (response) in

            Debug.log(object: "Debut téléchargement page : https://vegoresto.fr/restos-fichier-xml/")

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

    func loadComments(from restaurant: Restaurant, completion :  @escaping () -> Void ) {

        if let url = restaurant.absolute_url {

        Debug.log(object: "Téléchargement page : \(url)")

        Alamofire.request(url).responseData { (response) in

            Debug.log(object: "Debut téléchargement page : \(url)")

            switch response.result {
            case .success:
                Debug.log(object: "Validation Successful")
            case .failure(let error):
                Debug.log(object: "Faillure loadComments\(error)")
            }

            if let dataCompressed = response.data {

                if let decompressedData = NSData(data: dataCompressed).gunzipped() {

                    if let decompressedXML: String = String(data: decompressedData as Data, encoding: String.Encoding.utf8) {

                        Debug.log(object: "Decompression XML : OK")

                        //print("resultat = \(decompressedXML)")

                        self.parseHtmlCommentPage(html: decompressedXML, restaurant: restaurant)

                        completion()

                    }
                }
            }
            }
        }

    }

    func parseHtmlCommentPage(html: String, restaurant: Restaurant) {

        Debug.log(object: "Func[parseXMLCommentPage]")

        //let indexStartComment = html.localizedStandardRange(of: "<div id=\"comments\" class=\"comments-area\">")

        //let indexEndComment = html.localizedStandardRange(of: "<!-- #comments -->")

        //print("start = \(indexStartComment) end = \(indexEndComment)")

        if let doc = Kanna.HTML(html : html, encoding: String.Encoding.utf8) {

            // Search for nodes by XPath

            let entityComment =  NSEntityDescription.entity(forEntityName: "Comment", in: self.managedContext)

            for article in doc.xpath("//article") {

                let identifiant: String? = (article["id"])

                if let _nouvel_identifiant = identifiant {

                    print("news comment 0")

                    if let new_comment = (NSManagedObject(entity: entityComment!, insertInto: self.managedContext) as? Comment) {

                        print("news comment")

                        let author = doc.xpath("//article[contains(@id,'\(_nouvel_identifiant)')]/div/h3").first?.text

                        let time = doc.xpath("//article[contains(@id,'\(_nouvel_identifiant)')]/div/time").first?.text

                        let contentComment = doc.xpath("//article[contains(@id,'\(_nouvel_identifiant)')]/div/p").first?.text

                        new_comment.time = time
                        new_comment.author = author
                        new_comment.content = contentComment

                        restaurant.addComment(newComment: new_comment)

                        new_comment.restaurant =  restaurant

                    }
                }
            }

            var numberStars: Double = Double(html.countInstances(of: "https://vegoresto.fr/wp-content/plugins/wp-postratings/images/stars/rating_on.gif"))

            if html.countInstances(of: "https://vegoresto.fr/wp-content/plugins/wp-postratings/images/stars/rating_half.gif") >= 1 {

                numberStars = numberStars + 0.5
            }

            restaurant.rating = NSNumber(value: numberStars)

            do {

                try self.managedContext.save()

            } catch _ {

                Debug.log(object: "erreur save managedContext")

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
