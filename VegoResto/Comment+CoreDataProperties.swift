//
//  CategorieCulinaire+CoreDataProperties.swift
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

extension Comment {

    @NSManaged var ident: NSNumber?
    @NSManaged var content: String?
    @NSManaged var time: String?
    @NSManaged var author: String?
    @NSManaged var rating: NSNumber?

    @NSManaged var restaurant: Restaurant?
    @NSManaged var childsComments: NSSet?

}
