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

@objc(Restaurant)
class Restaurant: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass

    var distance: Double = -1

    func addTag(tag: Tag) {

        let tags = self.mutableSetValueForKey("tags")
        tags.addObject(tag)

    }


    func getTagsAsArray() -> [Tag]? {
        var tmpTags: [Tag]?
        tmpTags = (self.tags?.allObjects) as? [Tag]

        return tmpTags
    }


    func update_distance_avec_localisation(seconde_localisation: CLLocationCoordinate2D) {

        if let longitude = self.lon?.doubleValue, latitude = self.lat?.doubleValue {

            let localisation_restaurant = CLLocation(latitude:  latitude, longitude: longitude )
            let seconde_localisation = CLLocation(latitude:  seconde_localisation.latitude, longitude: seconde_localisation.longitude )

            self.distance = seconde_localisation.distanceFromLocation( localisation_restaurant )
        }

    }


    func tags_are_present() -> ( is_vegan: Bool, is_gluten_free: Bool ) {

        var is_vegan = false
        var is_gluten_free = false

        if let array_tags: [Tag] = self.getTagsAsArray() {

            for tag in array_tags {

                if tag.name == "vegan"{

                    is_vegan = true

                } else if tag.name == "gluten-free"{

                    is_gluten_free = true

                }

            }

        }

        return (is_vegan, is_gluten_free)

    }


}
