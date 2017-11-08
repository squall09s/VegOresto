//
//  Horaire+CoreDataProperties.swift
//  VegOresto
//
//  Created by Nicolas on 17/09/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData

extension Horaire {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Horaire> {
        return NSFetchRequest<Horaire>(entityName: "Horaire")
    }

    @NSManaged public var idResto: NSNumber?
    @NSManaged public var dataL: String?
    @NSManaged public var dataMa: String?
    @NSManaged public var dataD: String?
    @NSManaged public var dataS: String?
    @NSManaged public var dataV: String?
    @NSManaged public var dataJ: String?
    @NSManaged public var dataMe: String?

}
