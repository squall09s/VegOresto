//
//  Restaurant.swift
//  VegoResto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData

@objc(Restaurant)
class Restaurant: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    
    func addTag(tag:Tag) {
        
        let tags = self.mutableSetValueForKey("tags")
        tags.addObject(tag)
        
    }
    
 
    func getTags() -> [Tag]? {
        var tmpTags: [Tag]?
        tmpTags = (self.tags?.allObjects) as? [Tag]
        
        return tmpTags
    }
    
    
    
}
