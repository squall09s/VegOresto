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
    
    static internal func map(name: String, context: NSManagedObjectContext) -> CategorieCulinaire {
        if let category = context.getCategorieCulinaire(name: name) {
            return category
        }
        let category = CategorieCulinaire(context: context)
        category.name = name
        return category
    }

    func addRestaurant(restaurant: Restaurant) {
        let restaurants = self.mutableSetValue(forKey: "restaurants")
        restaurants.add(restaurant)
    }
}
