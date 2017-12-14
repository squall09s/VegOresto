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
    
    public var commentsSet: Set<Comment> {
        return self.comments as! Set<Comment>
    }

    public var commentsArray: [Comment] {
        return Array(commentsSet)
    }
    
    public var commentsNotDraftArray: [Comment] {
        return commentsArray.filter({ comment -> Bool in
            return !comment.isDraft
        })
    }

    public var commentsRootArray: [Comment] {
        return commentsArray.filter({ comment -> Bool in
            return !comment.isDraft && comment.isRoot
        })
    }
    
    public var categoriesCulinairesArray: [CategorieCulinaire] {
        return (self.categoriesCulinaire.allObjects as? [CategorieCulinaire]) ?? []
    }
    
    public func addCategorieCulinaire(_ category: CategorieCulinaire) {
        assert(category.managedObjectContext == self.managedObjectContext)
        let categoriesCulinaire = self.mutableSetValue(forKey: "categoriesCulinaire")
        categoriesCulinaire.add(category)
    }
    
    public func addCategorieCulinaire(name: String) {
        let category = CategorieCulinaire.map(name: name, context: self.managedObjectContext!)
        self.addCategorieCulinaire(category)
    }

    func setDistance(from userLocation: CLLocation) {
        if let venueLocation = self.location {
            self.distance = venueLocation.distance(from: userLocation)
        } else {
            self.distance = (-1)
        }
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
        return "facebook.com\(facebookURL.path)"
    }
    
    var facebookURL: URL? {
        guard let facebookStr = self.facebook else {
            return nil
        }
        return URL(string: facebookStr)
    }
    
    var displayCityName: String? {
        if let postalCode = self.postal_code?.trimmingCharacters(in: .whitespacesAndNewlines), postalCode.count == 5 {
            let dept = postalCode.prefix(2)
            let arrond = postalCode.suffix(2)
            if dept == "75", let arrondN = Int(arrond), 1 <= arrondN, arrondN <= 20 {
                if arrondN == 1 {
                    return "Paris 1er"
                } else {
                    return "Paris \(arrondN)ème"
                }
            }
        }
        return self.ville
    }
    
    // MARK: Mapping
    
    static internal func map(_ JSON: [String:Any], context: NSManagedObjectContext) -> Restaurant {
        let restaurantId = (JSON["id"] as? NSNumber)?.intValue ?? -1
        let restaurant = context.getRestaurant(identifier: restaurantId) ?? Restaurant(context: context)
        restaurant.mapping(map: Map(mappingType: .fromJSON, JSON: JSON))
        return restaurant
    }

    required convenience init?(map: Map) {
        assert(Thread.isMainThread)
        self.init(map: map, context: UserData.shared.viewContext)
    }
    
    convenience init?(map: Map, context: NSManagedObjectContext) {
        self.init(context: context)
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.identifier <-  map["id"]
        self.name <-  map["title"]
        self.ville <-  map["ville"]
        self.postal_code <- map["cp"]
        self.phone <- map["tel_public"]
        self.montant_moyen <- map["prix"]
        self.facebook <- map["fb"]
        self.website <- map["site"]
        self.mail <- map["email"]
        self.absolute_url <- map["permalink"]
        
        self.animaux_bienvenus = NSNumber(value: ((map.JSON["anim"] as? String) == "oui"))
        self.isVegan = NSNumber(value: (map.JSON["vegan"] as? Int == 1))
        
        if let address = map.JSON["adresse"] as? String {
            self.address = address.removingHTMLTags()
        }
        
        if let resume = map.JSON["accroche"] as? String {
            self.resume = resume.removingHTMLTags()
        }
        
        if let montant_moyen = map.JSON["prix"] as? String {
            self.montant_moyen = Restaurant.mapMontantMoyen(montant_moyen)
        }
        
        if let type_etablissement = map.JSON["type"] as? String {
            self.type_etablissement = Restaurant.mapTypeEtablissement(type_etablissement)
        }
        
        if let gastr = map.JSON["gastr"] as? [String] {
            self.influence_gastronomique = Restaurant.mapInfluenceGastro(gastr)
        }
        
        if let moyensPaiement = map.JSON["payment"] as? [String] {
            self.moyens_de_paiement = Restaurant.mapMoyensDePaiement(moyensPaiement)
        }
        
        if let ambiances = map.JSON["ambiance"] as? [String] {
            self.ambiance = Restaurant.mapAmbiance(ambiances)
        }
        
        if let votes = map.JSON["votes"] as? [String:Any], let avg = votes["avg"] as? Double {
            self.rating = NSNumber(value: avg)
        }
        
        if let imageURLStrings = map.JSON["thumbnails"] as? [String] {
            self.image = imageURLStrings.joined(separator: "|")
        }
        
        if let lon = map.JSON["lon"] as? Double, let lat = map.JSON["lat"] as? Double {
            self.lat = NSNumber(value: lat)
            self.lon = NSNumber(value: lon)
            self.radius = NSNumber(value: (map.JSON["rad"] as? Double) ?? 0)
        }
        
        if let categories = map.JSON["cat"] as? [String] {
            for categoryName in categories {
                addCategorieCulinaire(name: Restaurant.mapCategorieCulinaireName(categoryName))
            }
        }
    }
    
    // MARK: Mapping Helpers
    
    static func mapMontantMoyen(_ key: String) -> String {
        let d = [
            "montant_8": "inférieur à 8€",
            "montant_15": "inférieur à 15€",
            "montant_1530": "15-30€",
            "montant_3060": "30-60€",
            "montant_60": "plus de 60€"
        ]
        guard let val = d[key] else {
            Debug.log(object: "ERROR - [mapMontantMoyen] key \(key) not found")
            return key
        }
        return val
    }
    
    static func mapCategorieCulinaireName(_ cat: String) -> String {
        let d = [
            "bio": "Bio",
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
            "tarte": "Salades"
        ]
        guard let val = d[cat] else {
            Debug.log(object: "ERROR - [mapCategorieCulinaireName] key \(cat) not found")
            return cat
        }
        return val
    }
    
    static func mapTypeEtablissement(_ typeEtablissement: String) -> String {
        let d = [
            "vpc": "Restauration rapide, à emporter ou à domicile",
            "chambre": "Chambre d'hôtes",
            "resto": "Restaurant",
            "hotel": "Hôtel-restaurant"
        ]
        guard let val = d[typeEtablissement] else {
            Debug.log(object: "ERROR - [mapTypeEtablissement] key \(typeEtablissement) not found")
            return typeEtablissement
        }
        return val
    }
    
    static func mapInfluenceGastro(_ influences: [String]) -> String {
        let d = [
            "francais_gastro": "Gastronomique français",
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
            "creole": "Créole"
        ]
        return influences.map({ key -> String in
            guard let val = d[key] else {
                Debug.log(object: "ERROR - [mapInfluenceGastro] key \(key) not found")
                return key
            }
            return val
        }).joined(separator: ", ")
    }
    
    static func mapMoyensDePaiement(_ moyensPaiement: [String]) -> String {
        let d = [
            "cb": "Carte Bleue",
            "cheque": "Chèque",
            "espece": "Espèces",
            "ticket": "Ticket resto",
            "ae": "American Express",
            "vacances": "Chèque vacances"
        ]
        return moyensPaiement.map({ key -> String in
            guard let val = d[key] else {
                Debug.log(object: "ERROR - [mapMoyensDePaiement] key \(key) not found")
                return key
            }
            return val
        }).joined(separator: ", ")
    }
    
    static func mapAmbiance(_ ambiances: [String]) -> String {
        let d = [
            "branche": "Branché",
            "bistro": "Bistrot de caractère",
            "cosy": "Cosy",
            "spectacle": "Spectacle",
            "patrimoine": "Patrimoine",
            "vintage": "Vintage",
            "jardin": "Jardin",
            "hote": "Table d’hôte",
            "romantique": "Romantique",
            "dansant": "Dansant",
            "eau": "Au bord de l'eau"
        ]
        return ambiances.map({ key -> String in
            guard let val = d[key] else {
                Debug.log(object: "ERROR - [mapAmbiance] key \(key) not found")
                return key
            }
            return val
        }).joined(separator: ", ")
    }
}
