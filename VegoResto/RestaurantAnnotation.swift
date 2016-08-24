//
//  RestaurantAnnotation.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 31/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import FBAnnotationClusteringSwift

class RestaurantAnnotation: FBAnnotation {

    var restaurant: Restaurant? = nil

init(_restaurant: Restaurant) {

    self.restaurant = _restaurant

    super.init()

    self.title = _restaurant.name


    }


}
