//
//  Restaurant+CoreDataProperties.swift
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

extension Restaurant {
    // properties
    @NSManaged var identifier: NSNumber?
    @NSManaged var absolute_url: String?
    @NSManaged var address: String?
    @NSManaged var terrasse: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var radius: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var ville: String?
    @NSManaged var postal_code: NSString?
    @NSManaged var resume: String?
    @NSManaged var type_etablissement: String?
    @NSManaged var facebook: String?
    @NSManaged var website: String?
    @NSManaged var montant_moyen: String?
    @NSManaged var moyens_de_paiement: String?
    @NSManaged var animaux_bienvenus: NSNumber?
    @NSManaged var favoris: NSNumber
    @NSManaged var influence_gastronomique: String?
    @NSManaged var ambiance: String?
    @NSManaged var image: String?
    @NSManaged var mail: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var isVegan: NSNumber

    // relationships
    @NSManaged var categoriesCulinaire: NSSet
    @NSManaged var comments: NSSet
}
