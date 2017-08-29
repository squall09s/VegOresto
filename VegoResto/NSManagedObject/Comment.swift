//
//  CategorieCulinaire
//  VegoResto
//
//  Created by Laurent Nicolas on 16/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

@objc(Comment)
class Comment: NSManagedObject, Mappable {

    @NSManaged var title: String?
    @NSManaged var shootingDate: String?
    @NSManaged var elements: NSSet?

    private var elementsArray: [Image]?

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {

        super.init(entity: entity, insertInto: UserData.sharedInstance.managedContext)
    }

    required init?(map: Map) {

        let ctx = UserData.sharedInstance.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "Comment", in: ctx)

        super.init(entity: entity!, insertInto: ctx)

        mapping(map: map)

    }

    func mapping(map: Map) {

        content <-  map["content.rendered"]

        if let _content = content {
            content = UserData.sharedInstance.cleanString(str: _content)
        }
        time <- map["time"]
        author <- map["author_name"]

        childsComments =  NSSet()

    }

    func addChildComment(newComment: Comment) {

        let comments = self.mutableSetValue(forKey: "childsComments")
        comments.add(newComment)

    }

    func getChildsCommentsAsArray() -> [Comment]? {

        var tmpComments: [Comment]?
        tmpComments = (self.childsComments?.allObjects) as? [Comment]

        return tmpComments
    }

}
