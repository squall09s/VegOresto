//
//  Restaurant.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import ObjectMapper

enum CategorieRestaurant {

    case Vegan
    case Végétarien
    case VeganFriendly
}

@objc(Restaurant)
class Restaurant: NSManagedObject, Mappable {

    var distance: CLLocationDistance = (-1)
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    func addCategorieCulinaire(newCategorie: CategorieCulinaire) {

        let categoriesCulinaire = self.mutableSetValue(forKey: "categoriesCulinaire")
        categoriesCulinaire.add(newCategorie)

    }
    
    public func addComment(_ comment: Comment) {
        let comments = self.comments.mutableCopy() as! NSMutableOrderedSet
        comments.add(comment)
        self.comments = comments.copy() as! NSOrderedSet
    }

    // @TODO maybe a var?
    public func getComments() -> [Comment] {
        return (self.comments.array as? [Comment]) ?? []
    }

    public var categoriesCulinairesArray: [CategorieCulinaire] {
        return (self.categoriesCulinaire.allObjects as? [CategorieCulinaire]) ?? []
    }

    func setDistance(from userLocation: CLLocation) {
        if let venueLocation = self.location {
            self.distance = venueLocation.distance(from: userLocation)
        } else {
            self.distance = (-1)
        }
    }

    // @TODO fix typo in the func name
    func is_glutonFree() -> Bool {

        let array_cats: [CategorieCulinaire] = categoriesCulinairesArray

        for current_cat in array_cats {

            if current_cat.name == "gluten-free"{

                return true

            }

        }

        return false

    }
    
    var category: CategorieRestaurant {
        if isVegan.boolValue {
            return CategorieRestaurant.Vegan
        }
        if categoriesCulinairesArray.contains(where: { cat -> Bool in
            return cat.name == "Végétarien"
        }) {
            return CategorieRestaurant.Végétarien
        }
        return CategorieRestaurant.VeganFriendly
    }

    func updateDataMontantMoyen() {

        let dico : [ String : String ] = ["montant_8": "inférieur à 8€",
                                          "montant_15": "inférieur à 15€",
                                          "montant_1530": "15-30€",
                                          "montant_3060": "30-60€",
                                          "montant_60": "plus de 60€"]

        if let _key = self.montant_moyen {

            if let val = dico[_key] {

                self.montant_moyen = val

            } else {

                Debug.log(object: "ERROR - [updateDataMontantMoyen] key \(_key) not found")
            }

        }
    }

    func updateDataTypeEtablissement() {

        let dico : [ String : String ] = ["vpc": "Restauration rapide, à emporter ou à domicile",
                                          "chambre": "Chambre d'hôtes",
                                          "resto": "Restaurant",
                                          "hotel": "Hôtel-restaurant"]

        if let _key = self.type_etablissement {

            if let val = dico[_key] {

                self.type_etablissement = val

            } else {

                Debug.log(object: "ERROR - [updateDataTypeEtablissement] key \(_key) not found")
            }

        }
    }

    func updateDataTypeAmbiance(ambiances: [String]) {

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

        for _key in ambiances {

            if let val = dico[_key] {

                if i > 0 {

                    resultat += ", "
                }

                resultat += val

                i += 1

            } else {

                Debug.log(object: "ERROR - [updateDataTypeAmbiance] key \(_key) not found")
            }

        }

        self.ambiance = resultat
    }

    func updateDataInfluenceGastro(influances: [String]) {

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

                for _key in influances {

                    if let val = dico[_key] {

                        if i > 0 {

                            resultat += ", "
                        }

                        resultat += val

                        i += 1

                    } else {

                        Debug.log(object: "ERROR - [updateDataInfluenceGastro] key \(_key) not found")
                    }
                }

        self.influence_gastronomique = resultat

    }

    func updateDataCategorieCulinaire(_cat: String) -> String {

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
                                          "tradi": "Vegan-friendly",
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
            return ""
        }
    }

    func updateDataMoyensDePaiement(moyensPaiement: [String]) {

        let dico : [ String : String ] = ["cb": "Carte Bleue",
                                          "cheque": "Chèque",
                                          "espece": "Espèces",
                                          "ticket": "Ticket resto",
                                          "ae": "American Express",
                                          "vacances": "Chèque vacances"]

        var i = 0

        var resultat = ""

                for _key in moyensPaiement {

                    if let val = dico[_key] {

                        if i > 0 {

                            resultat += ", "
                        }

                        resultat += val

                        i += 1

                    } else {

                        Debug.log(object: "ERROR - [updateDataMoyensDePaiement] key \(_key) not found")
                    }

        }

        self.moyens_de_paiement = resultat
    }

    var coordinate: CLLocationCoordinate2D? {
        if let latitude = lat?.doubleValue, let longitude = lon?.doubleValue {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }
    
    var location: CLLocation? {
        return coordinate?.location
    }
    
    var imagesURLs: [URL] {
        return (self.image ?? "").components(separatedBy: "|").flatMap({ (urlString: String) -> URL? in
            return URL(string: urlString.replacingOccurrences(of: "https://vegoresto.l214.in", with: "https://vegoresto.fr"))
        })
    }
    
    var facebookPage: String? {
        guard var facebookStr = self.facebook else {
            return nil
        }
        if !facebookStr.starts(with: "http") {
            facebookStr = "https://\(facebookStr)"
        }
        guard let facebookURL = URL(string: facebookStr), facebookURL.host == "www.facebook.com" || facebookURL.host == "facebook.com" else {
            return nil
        }
        let pathComponents = facebookURL.pathComponents
        return pathComponents.count >= 2 ? pathComponents[1] : nil
    }
    
    var facebookURL: URL? {
        guard let facebookPage = self.facebookPage else {
            if let facebookStr = self.facebook {
                return URL(string: facebookStr)
            }
            return nil
        }
        return URL(string: "https://www.facebook.com/\(facebookPage)/")
    }
    
    // MARK: Mapping

    required init?(map: Map) {
        assert(Thread.isMainThread)
        
        let context = UserData.shared.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)
        super.init(entity: entity!, insertInto: context)
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        identifier <-  map["id"]
        name <-  map["title"]
        ville <-  map["ville"]
        
        if let _img: [String] = map.JSON["thumbnails"] as? [String] {
            
            var image_str_array = ""
            
            var _index = 0
            for _imgTmp: String in _img {
                
                if _index == 0 {
                    image_str_array = _imgTmp
                } else {
                    image_str_array += ( "|" + _imgTmp)
                }
                
                _index += 1
            }
            
            self.image = image_str_array
        }
        
        phone <- map["tel_public"]
        montant_moyen <- map["prix"]
        
        self.facebook <- map["fb"]
        self.website <- map["site"]
        self.mail <- map["email"]
        
        self.address <- map["adresse"]
        self.address = cleanHTMLString(str: self.address ?? "")
        
        self.resume <- map["accroche"]
        self.resume = cleanHTMLString(str: self.resume ?? "")
        
        self.montant_moyen <- map["prix"]
        
        self.updateDataMontantMoyen()
        
        self.absolute_url <- map["permalink"]
        self.type_etablissement <- map["type"]
        self.updateDataTypeEtablissement()
        
        if let _cat = map.JSON["cat"] as? [String] {
            
            categoriesCulinaire = NSSet()
            
            for currentCat in _cat {
                CategorieCulinaire.createCategorie(for: self, catname: self.updateDataCategorieCulinaire(_cat:  currentCat) )
            }
        }
        
        if let _gast = map.JSON["gastr"] as? [String] {
            
            self.updateDataInfluenceGastro(influances: _gast)
        }
        
        if let _moyensPaiement = map.JSON["payment"] as? [String] {
            
            self.updateDataMoyensDePaiement(moyensPaiement: _moyensPaiement)
        }
        
        if let _ambiances = map.JSON["ambiance"] as? [String] {
            self.updateDataTypeAmbiance(ambiances: _ambiances)
        }
        
        if let _votes = map.JSON["votes"] as? [String : Any] {
            
            if let _avg = _votes["avg"] as? Double {
                self.rating = NSNumber(value: _avg)
            }
        }
        
        if let _lon = map.JSON["lon"] as? Double,
            let _lat = map.JSON["lat"] as? Double {
            self.lat = NSNumber(value: _lat)
            self.lon = NSNumber(value: _lon)
            if let _radius = map.JSON["rad"] as? Double {
                self.radius = NSNumber(value: _radius)
            } else {
                self.radius = NSNumber(value: 0)
            }
        }
        
        if let _anim = map.JSON["anim"] as? String {
            
            self.animaux_bienvenus = NSNumber(value: (_anim == "oui") )
            
        } else {
            
            self.animaux_bienvenus = NSNumber(value: false )
        }
        
        if let _veg = map.JSON["vegan"] as? Int {
            
            self.isVegan = NSNumber(value: (_veg == 1) )
            
        } else {
            
            self.isVegan = NSNumber(value: false )
        }
        
        self.comments =  NSOrderedSet()
    }
}
