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
    @NSManaged var identifier: NSNumber?
    @NSManaged var terrasse: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var ville: String?
    @NSManaged var resume: String?
    @NSManaged var type_etablissement: String?
    @NSManaged var facebook: String?
    @NSManaged var website: String?
    @NSManaged var montant_moyen: String?
    @NSManaged var tags: NSSet?
    @NSManaged var moyens_de_paiement: String?
    @NSManaged var langues_parlees: String?
    @NSManaged var animaux_bienvenus: NSNumber?
    @NSManaged var favoris: NSNumber
    @NSManaged var influence_gastronomique: String?
    @NSManaged var ambiance: String?
    @NSManaged var fermeture: String?
    @NSManaged var image: String?


    @NSManaged var h_lundi: String?
    @NSManaged var h_mardi: String?
    @NSManaged var h_mercredi: String?
    @NSManaged var h_jeudi: String?
    @NSManaged var h_vendredi: String?
    @NSManaged var h_samedi: String?
    @NSManaged var h_dimanche: String?

    @NSManaged var h_matin: String?
    @NSManaged var h_midi: String?
    @NSManaged var h_ap_midi: String?
    @NSManaged var h_soir: String?
    @NSManaged var h_nuit: String?

}
