//
//  Tag.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 16/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData

@objc(Tag)
class Tag: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func addRestaurant(restaurant: Restaurant) {

        let restaurants = self.mutableSetValue(forKey: "restaurants")
        restaurants.add(restaurant)

    }
}
