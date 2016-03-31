//
//  UserData.swift
//  VegoResto
//
//  Created by Laurent Nicolason 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//


import UIKit
import CoreData

class UserData: NSObject {
    
    static let sharedInstance = UserData()
    
    var managedContext = ( UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext
   
    
    private override init() {
        
        super.init()
        
    }
    
    
    
    func getRestaurants() -> [Restaurant] {
        
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        
        do{
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [Restaurant]
            
        } catch _ {
            
            return [Restaurant]()
            
        }
        
    }
    
    
    
    func chargerDonneesLocales(){
        
        
        
        if self.getRestaurants().count > 0 {
            return
        }
        
        
        let entityStatut =  NSEntityDescription.entityForName("Restaurant",  inManagedObjectContext:managedContext)
        
        
        if let path = NSBundle.mainBundle().pathForResource("restaurants", ofType: "json"){
        
   
            
            if let fileContents: NSData = NSData(contentsOfFile: path){
            
            
            do {
                
                
                let json = try NSJSONSerialization.JSONObjectWithData(fileContents, options: .AllowFragments)
                
                
                if let restaurants = json as? [AnyObject] {
                    
                    
                    for restaurant in restaurants {
                        
                        
                        let new_restaurant = NSManagedObject(entity: entityStatut!, insertIntoManagedObjectContext: managedContext) as! Restaurant
                        
                        new_restaurant.name = restaurant["name"] as? String
                        new_restaurant.website = restaurant["website"] as? String
                        new_restaurant.absolute_url = restaurant["absolute_url"] as? String
                        new_restaurant.address = restaurant["address"] as? String
                        new_restaurant.phone = restaurant["phone"] as? String
                        new_restaurant.national_phone_number = restaurant["national_phone_number"] as? String
                        new_restaurant.international_phone_number = restaurant["international_phone_number"] as? String
                        
                        new_restaurant.id = restaurant["id"] as? NSNumber
                        new_restaurant.lat = restaurant["lat"] as? NSNumber
                        new_restaurant.lon = restaurant["lon"] as? NSNumber
                        
                        
                    }
                    
                }
                
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            }
            
            
    
        }
        
        
        
        
        do {
            try managedContext.save()
        }
        catch _ {
            print("erreur")
        }
        
        
    }
    
    
    
}
