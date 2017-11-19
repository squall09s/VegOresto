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

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // MARK: Getters
    
    public var isDraft: Bool {
        return (identifier?.intValue ?? (-1)) <= 0
    }
    
    public var isRoot: Bool {
        return (parentId?.intValue ?? 0) <= 0
    }
    
    // MARK: Mapping

    static internal func map(_ JSON: [String:Any], context: NSManagedObjectContext) -> Comment {
        let commentId = (JSON["id"] as? NSNumber)?.intValue ?? -1
        let comment = context.getComment(identifier: commentId) ?? Comment(context: context)
        comment.mapping(map: Map(mappingType: .fromJSON, JSON: JSON))
        return comment
    }
    
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

        identifier <-  map["id"]
        time <- map["time"]
        author <- map["author_name"]
        email <- map["author_email"]
        parentId <- map["parent"]
        status <- map["status"]
        rating <- map["vote"]

        if let _firstImageDico: [String : Any] = ((map.JSON["images"] as? [Any])?.first as? [String : Any]),
           let _dicoFirstImageDetail = _firstImageDico["com_illu"] as? [String : Any],
           let urlImage = _dicoFirstImageDetail["url"] as? String {
            self.imageUrl = urlImage
        }
    }
}
