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
        return RequestManager.shared.get(url: url).then { (result : [String : Any]) -> [Restaurant] in
            let restaurants = Array(result.values).flatMap({ (dict) -> Restaurant? in
                guard let _dict = dict as? [String:Any] else {
                    return nil
                }
                let restaurantId = (_dict["id"] as? NSNumber)?.intValue ?? -1
                if let restaurant = UserData.shared.getRestaurant(identifier: restaurantId) {
                    restaurant.mapping(map: Map(mappingType: .fromJSON, JSON: _dict))
                    return restaurant
                } else if let restaurant = Restaurant(JSON: _dict) {
                    return restaurant
                }
                return nil
            })

            // save context
            UserData.shared.saveContext()

            return restaurants
        }
    }
    
    public func loadHoraires() -> Promise<[Horaire]> {
        let url = getUrl("/wp-content/cache/horaires.json")
        return RequestManager.shared.get(url: url).then(execute: { (result: [String:Any]) -> [Horaire] in
            return Array(result.values).flatMap({ (dict) -> Horaire? in
                guard let _dict = dict as? [String:Any],
                    let horaire = Horaire(JSON: _dict) else {
                        return nil
                }
                return horaire
            })
        })
    }
    
    public func loadComments(restaurant: Restaurant) -> Promise<[Comment]> {
        let url = getUrl("/wp-json/wp/v2/comments?post=\(restaurant.identifier?.intValue ?? 0)")
        return RequestManager.shared.get(url: url).then(execute: { (comments: [Comment]) -> [Comment] in
            
            assert(Thread.isMainThread)
            let context = UserData.shared.viewContext
            
            // remove old comments
            for comment in restaurant.getComments() {
                context.delete(comment)
            }
            
            // map to restaurant
            for comment in comments {
                comment.restaurant = restaurant
            }
            
            // set restaurant comments
            restaurant.comments = NSSet(array: comments)
            
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
            restaurant.addComment(newComment: comment)
            return comment
        })
    }
}
