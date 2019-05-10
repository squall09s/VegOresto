//
//  CategorieCulinaire+CoreDataProperties.swift
//  VegOresto
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

    @NSManaged var identifier: NSNumber?
    @NSManaged var content: String?
    @NSManaged var date: Date?
    @NSManaged var email: String?
    @NSManaged var author: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var parentId: NSNumber?

    @NSManaged var status: String?
    @NSManaged var imageUrl: String?

    @NSManaged var restaurant: Restaurant?

}
