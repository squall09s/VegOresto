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
    
    
    
    func tags_are_present() -> ( is_vegan : Bool , is_gluten_free : Bool ){
        
        var is_vegan = false
        var is_gluten_free = false
        
        if let array_tags : [Tag] = self.getTags(){
            
            for tag in array_tags{
                
                if tag.name == "vegan"{
                    
                    is_vegan = true
                    
                }else if tag.name == "gluten-free"{
                    
                    is_gluten_free = true
                    
                }
                
            }
            
        }
        
        return (is_vegan , is_gluten_free)
        
    }
    
    
}
