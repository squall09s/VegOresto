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

    @NSManaged var absolute_url: String?    //ok
    @NSManaged var address: String?    //ok
    @NSManaged var identifier: NSNumber?    //ok
    @NSManaged var terrasse: NSNumber?
    @NSManaged var lat: NSNumber?    //ok
    @NSManaged var lon: NSNumber?    //ok
    @NSManaged var name: String?    //ok
    @NSManaged var phone: String?    //ok
    @NSManaged var ville: String?    //ok
    @NSManaged var resume: String?    //ok
    @NSManaged var type_etablissement: String?    //ok
    @NSManaged var facebook: String?    //ok
    @NSManaged var website: String?    //ok
    @NSManaged var montant_moyen: String?    //ok
    @NSManaged var categoriesCulinaire: NSSet?    //ok
    @NSManaged var comments: NSSet?    //ok
    @NSManaged var moyens_de_paiement: String?    //ok
    @NSManaged var animaux_bienvenus: NSNumber?
    @NSManaged var favoris: NSNumber    //ok
    @NSManaged var influence_gastronomique: String?    //ok
    @NSManaged var ambiance: String?    //ok
    @NSManaged var image: String?
    @NSManaged var mail: String?    //ok
    @NSManaged var rating: NSNumber?

    @NSManaged var h_lundi: String?    //ok
    @NSManaged var h_mardi: String?    //ok
    @NSManaged var h_mercredi: String?    //ok
    @NSManaged var h_jeudi: String?    //ok
    @NSManaged var h_vendredi: String?    //ok
    @NSManaged var h_samedi: String?    //ok
    @NSManaged var h_dimanche: String?    //ok

}
