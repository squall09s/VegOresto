//
//  ContractManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

class WebRequestManager {
    static let shared = WebRequestManager()

    private func getUrl(_ path: String) -> URL {
        return APIConfig.apiBaseUrl.appendingPathComponent(path)
    }

    public func loadRestaurants() -> Promise<[Restaurant]> {
        let url = getUrl("/wp-json/vg/v1/restos.json")
        return RequestManager.shared.get(url: url).then { (result: [String:Any]) -> Promise<[Restaurant]> in
            return UserData.shared.performBackgroundMapping({ context -> [Restaurant] in
                return Array(result.values).flatMap({ (dict) -> Restaurant? in
                    guard let _dict = dict as? [String:Any] else {
                        return nil
                    }
                    return Restaurant.map(_dict, context: context)
                })
            }, autosave: true)
        }
    }
    
    public func loadHoraires() -> Promise<[Horaire]> {
        let url = getUrl("/wp-json/vg/v1/horaires.json")
        return RequestManager.shared.get(url: url).then(execute: { (result: [String:Any]) -> Promise<[Horaire]> in
            return UserData.shared.performBackgroundMapping({ context -> [Horaire] in
                return Array(result.values).flatMap({ (dict) -> Horaire? in
                    guard let _dict = dict as? [String:Any] else {
                        return nil
                    }
                    return Horaire.map(_dict, context: context)
                })
            }, autosave: true)
        })
    }
    
    public func loadComments(restaurant: Restaurant) -> Promise<[Comment]> {
        let url = getUrl("/wp-json/wp/v2/comments?post=\(restaurant.identifier?.intValue ?? 0)")
        return RequestManager.shared.get(url: url).then(execute: { (comments: [Comment]) -> [Comment] in
            assert(Thread.isMainThread)
            
            // remove old comments
            let context = UserData.shared.viewContext
            let toDelete = Set(restaurant.commentsArray).subtracting(comments)
            for comment in toDelete {
                context.delete(comment)
            }
            
            // set comments to restaurants
            restaurant.comments = NSOrderedSet(array: comments)

            // save context
            UserData.shared.saveViewContext()

            return comments
        })
    }
    
    public func postImageMedia(image: UIImage) -> Promise<String> {
        let url = getUrl("/wp-json/vegoresto/v1/media")
        return RequestManager.shared.post(url: url, image: image).then(execute: { (object: Any) -> String in
            guard let dict = object as? [String:Any], let imageId = dict["id"] as? Int else {
                throw RequestManagerError.jsonError
            }
            return String(imageId)
        })
    }

    public func postComment(restaurant: Restaurant, comment: Comment) -> Promise<Comment> {
        let url = getUrl("/wp-json/vegoresto/v1/comments")
        
        var parameters: [String:String] = [
            "post": String(restaurant.identifier?.intValue ?? -1),
            "content": (comment.content ?? ""),
            "author_name": (comment.author ?? "Invite"),
            "author_email": (comment.email ?? "Noname@mail.fr"),
            ]
        if let vote = comment.rating?.intValue, vote > 0 && vote < 6 {
            parameters["vote"] = String(vote)
        }
        if let imageComment = comment.temporaryImageIdentSend {
            parameters["images"] = imageComment
        }
        if let parentId = comment.parentId?.intValue {
            parameters["parent"] = String(parentId)
        }
        
        return RequestManager.shared.post(url: url, parameters: parameters, encoding: URLEncoding.queryString).then(execute: { (result: Any) -> Comment in
            guard let dict = result as? [String:Any], let comment = Comment(JSON: dict) else {
                throw RequestManagerError.jsonError
            }
            restaurant.addComment(comment)
            return comment
        })
    }
}
