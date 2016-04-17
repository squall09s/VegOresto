//
//  Restaurant+CoreDataProperties.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 16/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var absolute_url: String?
    @NSManaged var address: String?
    @NSManaged var id: NSNumber?
    @NSManaged var international_phone_number: String?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var name: String?
    @NSManaged var national_phone_number: String?
    @NSManaged var phone: String?
    @NSManaged var website: String?
    @NSManaged var tags: NSSet?

}
