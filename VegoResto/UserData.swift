//
//  UserData.swift
//  VegoResto
//
//  Created by Laurent Nicolason 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//


import UIKit
import CoreData
import CoreLocation

class UserData: NSObject,  CLLocationManagerDelegate {
    
    static let sharedInstance = UserData()
    
    private var locationmanager : CLLocationManager?
    var location : CLLocationCoordinate2D?
    
    var managedContext = ( UIApplication.sharedApplication().delegate as! AppDelegate ).managedObjectContext
   
    
    private override init() {
        
        super.init()
        
        
        
        self.locationmanager = CLLocationManager()
        //locationmanager?.startUpdatingLocation()
        //locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.requestWhenInUseAuthorization()
        self.locationmanager?.startUpdatingLocation()
        self.locationmanager?.delegate = self
        
        
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
        let entityTag =  NSEntityDescription.entityForName("Tag",  inManagedObjectContext:managedContext)
        
        
        if let path = NSBundle.mainBundle().pathForResource("restaurants", ofType: "json"){
        
   
            
            if let fileContents: NSData = NSData(contentsOfFile: path){
            
            
            do {
                
                
                let json = try NSJSONSerialization.JSONObjectWithData(fileContents, options: .AllowFragments)
                
                
                if let restaurants = json as? [AnyObject] {
                    
                    
                    for restaurant in restaurants {
                        
                        
                        let new_restaurant = NSManagedObject(entity: entityStatut!, insertIntoManagedObjectContext: managedContext) as! Restaurant
                        
                        new_restaurant.name = restaurant["name"] as? String
                        new_restaurant.name = new_restaurant.name?.stringByReplacingOccurrencesOfString("&#039", withString: "'")
                        
                        new_restaurant.website = restaurant["website"] as? String
                        new_restaurant.absolute_url = restaurant["absolute_url"] as? String
                        new_restaurant.address = (restaurant["address"] as? String)?.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
                        new_restaurant.address = new_restaurant.address?.stringByReplacingOccurrencesOfString("&#039", withString: "'")
                        
                        new_restaurant.phone = restaurant["phone"] as? String
                        new_restaurant.national_phone_number = restaurant["national_phone_number"] as? String
                        new_restaurant.international_phone_number = restaurant["international_phone_number"] as? String
                        
                        new_restaurant.id = restaurant["id"] as? NSNumber
                        new_restaurant.lat = restaurant["lat"] as? NSNumber
                        new_restaurant.lon = restaurant["lon"] as? NSNumber
                        
                        new_restaurant.tags = NSSet()
                        
                        if let arrayTypes : [String] = restaurant["tags"] as? [String]{
                        
                        for type_name in arrayTypes {
                            
                            
                            let new_tag = NSManagedObject(entity: entityTag!, insertIntoManagedObjectContext: managedContext) as! Tag
                            
                            new_tag.name = type_name
                            
                            new_restaurant.addTag(new_tag)
                            
                        }
                        }
                    }
                    
                }
                
            } catch {
                Debug.log("error serializing JSON: \(error)")
            }
            }
            
        }
        
        
        
        
        do {
            try managedContext.save()
        }
        catch _ {
            Debug.log("erreur save managedContext")
        }
        
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        print("location update")
        
        let location = locations.last
        
        self.location = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        
    }
    
    
}
