//
//  CategorieCulinaire
//  VegOresto
//
//  Created by Laurent Nicolas on 16/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData

@objc(CategorieCulinaire)
class CategorieCulinaire: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    static func createCategorie(for restaurant: Restaurant, catname: String) {

        let entityCategorieCulinaire =  NSEntityDescription.entity(forEntityName: "CategorieCulinaire", in: UserData.sharedInstance.managedContext)

        if let new_cat = (NSManagedObject(entity: entityCategorieCulinaire!, insertInto: UserData.sharedInstance.managedContext) as? CategorieCulinaire) {

            new_cat.name = catname
            new_cat.restaurants = NSSet()

            restaurant.addCategorieCulinaire(newCategorie: new_cat)
            new_cat.addRestaurant(restaurant: restaurant)

        }

    }

    func addRestaurant(restaurant: Restaurant) {

        let restaurants = self.mutableSetValue(forKey: "restaurants")
        restaurants.add(restaurant)

    }
}
