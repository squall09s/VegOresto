//
//  Restaurant.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData
import MapKit

enum CategorieRestaurant {

    case Vegan
    case Végétarien
    case Traditionnel
}

@objc(Restaurant)
class Restaurant: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass

    var distance: Double = -1

    func addCategorieCulinaire(newCategorie: CategorieCulinaire) {

        let categoriesCulinaire = self.mutableSetValue(forKey: "categoriesCulinaire")
        categoriesCulinaire.add(newCategorie)

    }

    func getCategoriesCulinaireAsArray() -> [CategorieCulinaire]? {

        var tmpCategorieCulinaires: [CategorieCulinaire]?
        tmpCategorieCulinaires = (self.categoriesCulinaire?.allObjects) as? [CategorieCulinaire]

        return tmpCategorieCulinaires
    }

    func update_distance_avec_localisation(seconde_localisation: CLLocationCoordinate2D) {

        if let longitude = self.lon?.doubleValue, let latitude = self.lat?.doubleValue {

            let localisation_restaurant = CLLocation(latitude:  latitude, longitude: longitude )
            let seconde_localisation = CLLocation(latitude:  seconde_localisation.latitude, longitude: seconde_localisation.longitude )

            self.distance = seconde_localisation.distance( from: localisation_restaurant )
        }
    }

    func is_glutonFree() -> Bool {

        let array_cats: [CategorieCulinaire] = self.getCategoriesCulinaireAsArray() ?? []

            for current_cat in array_cats {

                if current_cat.name == "gluten-free"{

                    return true

                }

            }

        return false

    }

    func categorie() -> CategorieRestaurant {

            let array_cats = self.getCategoriesCulinaireAsArray() ?? []

            for current_cat in array_cats {

                if current_cat.name == "Végétalien, végane" {

                    return CategorieRestaurant.Vegan
                }

            }

            for current_cat in array_cats {

                if current_cat.name == "Végétarien" {

                    return CategorieRestaurant.Végétarien
                }

            }

        return CategorieRestaurant.Traditionnel

    }

}
