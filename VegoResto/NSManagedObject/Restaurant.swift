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

    func addTag(tag: Tag) {

        let tags = self.mutableSetValue(forKey: "tags")
        tags.add(tag)

    }


    func getTagsAsArray() -> [Tag]? {
        var tmpTags: [Tag]?
        tmpTags = (self.tags?.allObjects) as? [Tag]

        return tmpTags
    }


    func update_distance_avec_localisation(seconde_localisation: CLLocationCoordinate2D) {

        if let longitude = self.lon?.doubleValue, let latitude = self.lat?.doubleValue {

            let localisation_restaurant = CLLocation(latitude:  latitude, longitude: longitude )
            let seconde_localisation = CLLocation(latitude:  seconde_localisation.latitude, longitude: seconde_localisation.longitude )

            self.distance = seconde_localisation.distance( from: localisation_restaurant )
        }

    }


    func is_glutonFree() -> Bool {

        let array_tags: [Tag] = self.getTagsAsArray() ?? []

            for tag in array_tags {

                if tag.name == "gluten-free"{

                    return true

                }

            }

        return false

    }

    func categorie() -> CategorieRestaurant {

            let tags = self.getTagsAsArray() ?? []

            for tag in tags {

                if tag.name == "vegan" {

                    return CategorieRestaurant.Vegan
                }

            }


            for tag in tags {

                if tag.name == "vege" {

                    return CategorieRestaurant.Végétarien
                }

            }

        return CategorieRestaurant.Traditionnel


    }


}
