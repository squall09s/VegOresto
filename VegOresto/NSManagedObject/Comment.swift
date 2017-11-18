//
//  Comment
//  VegOresto
//
//  Created by Laurent Nicolas on 16/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

@objc(Comment)
class Comment: NSManagedObject, Mappable {

    var temporaryImageIdentSend: String?

    @NSManaged var title: String?
    @NSManaged var shootingDate: String?
    @NSManaged var elements: NSSet?

    private var elementsArray: [Image]?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // MARK: Mapping

    required convenience init?(map: Map) {
        assert(Thread.isMainThread)
        self.init(map: map, context: UserData.shared.viewContext)
    }
    
    convenience init?(map: Map, context: NSManagedObjectContext) {
        self.init(context: context)
        mapping(map: map)
    }
    
    func mapping(map: Map) {

        content <-  map["content.rendered"]
        content = content?.removingHTMLTags()

        ident <-  map["id"]
        time <- map["time"]
        author <- map["author_name"]
        email <- map["author_email"]
        parentId <- map["parent"]
        postId <- map["post"]
        status <- map["status"]
        rating <- map["vote"]

        if let _firstImageDico: [String : Any] = ((map.JSON["images"] as? [Any])?.first as? [String : Any]),
           let _dicoFirstImageDetail = _firstImageDico["com_illu"] as? [String : Any],
           let urlImage = _dicoFirstImageDetail["url"] as? String {
            self.imageUrl = urlImage
        }
    }
}
