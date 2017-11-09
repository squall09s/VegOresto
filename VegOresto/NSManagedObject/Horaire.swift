//
//  Horaire+CoreDataClass.swift
//  VegOresto
//
//  Created by Nicolas on 17/09/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

@objc(Horaire)
class Horaire: NSManagedObject, Mappable {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {

        super.init(entity: entity, insertInto: UserData.sharedInstance.managedContext)
    }

    required init?(map: Map) {

        let ctx = UserData.sharedInstance.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "Horaire", in: ctx)

        super.init(entity: entity!, insertInto: ctx)

        mapping(map: map)

    }

    func mapping(map: Map) {

        self.idResto <-  map["id"]

        for identDay in ["l", "m", "M", "j", "v", "s", "d"] {

            var strData = ""

            if let newData = map[identDay].currentValue as? [[ String : Any ]] {

                for step in newData {

                    if let stepS = step["s"] as? String, let stepE = step["e"] as? String {

                        var stepStrData = "de \(stepS) à \( stepE)"

                        if strData.count > 0 {
                            stepStrData = " et " + stepStrData
                        }

                        strData += stepStrData

                    }
                }

            }

            switch identDay {
            case "l":
                self.dataL = strData
            case "m":
                self.dataMa = strData
            case "M":
                self.dataMe = strData
            case "j":
                self.dataJ = strData
            case "v":
                self.dataV = strData
            case "s":
                self.dataS = strData
            case "d":
                self.dataD = strData

            default:
                break
            }

        }

    }

}
