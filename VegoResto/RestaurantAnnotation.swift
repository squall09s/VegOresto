//
//  RestaurantAnnotation.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 31/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import FBAnnotationClusteringSwift

class RestaurantAnnotation : FBAnnotation {
    

var telephone: String?
var url: String?
var adresse: String?
var tags : [Tag]?
    
    
init(_titre: String?, _telephone: String?, _url: String?, _adresse : String? , _tag : [Tag]?) {

    self.telephone = _telephone
    self.url = _url
    self.adresse = _adresse
    self.tags = _tag
    
    super.init()
    
    self.title = _titre
    
    }


}
