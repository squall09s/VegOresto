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

extension CategorieCulinaire {

    @NSManaged var name: String?
    @NSManaged var restaurants: NSSet

}
