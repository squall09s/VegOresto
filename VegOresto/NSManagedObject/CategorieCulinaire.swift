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
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    static func createCategorie(for restaurant: Restaurant, catname: String) {
        let context = UserData.shared.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "CategorieCulinaire", in: context)

        if let category = (NSManagedObject(entity: entity!, insertInto: context) as? CategorieCulinaire) {
            category.name = catname
            category.restaurants = NSSet()

            restaurant.addCategorieCulinaire(newCategorie: category)
            category.addRestaurant(restaurant: restaurant)
        }
    }

    func addRestaurant(restaurant: Restaurant) {
        let restaurants = self.mutableSetValue(forKey: "restaurants")
        restaurants.add(restaurant)
    }
}
