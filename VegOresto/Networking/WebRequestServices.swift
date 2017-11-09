//
//  ContractServices.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

class WebRequestServices {

    static func listRestaurants(url: URL) -> Promise<[Restaurant]> {
        return RequestManager.doRequestList(method: .get, url: url).then { (result : [String : Any]) -> [Restaurant] in
            let restaurants = result.values.flatMap({ (dict) -> Restaurant? in
                guard let _dict = dict as? [String:Any] else {
                    return nil
                }
                let restaurantId = (_dict["id"] as? NSNumber)?.intValue ?? -1
                if let restaurant = UserData.sharedInstance.getRestaurantWithIdentifier(identifier: restaurantId) {
                    restaurant.mapping(map: Map(mappingType: .fromJSON, JSON: _dict))
                    return restaurant
                } else if let restaurant = Restaurant(JSON: _dict) {
                    return restaurant
                }
                return nil
            })
            
            // try to save the context
            do {
                try UserData.sharedInstance.managedContext.save()
            } catch {
                let nserror = error as NSError
                Debug.log(object: "listRestaurant : saveContext - Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            return Array(restaurants)
        }
    }

    static func loadHoraires(url: URL) -> Promise<[Horaire]> {
        return RequestManager.doRequestList(method: .get, url: url).then(execute: { (result: [String:Any]) -> [Horaire] in
            let horaires = result.values.flatMap({ (dict) -> Horaire? in
                guard let _dict = dict as? [String:Any],
                      let horaire = Horaire(JSON: _dict) else {
                    return nil
                }
                return horaire
            })
            return Array(horaires)
        })
    }

    static func listComments(url: URL) -> Promise<[Comment]> {
        return RequestManager.doRequest(method: .get, url: url)
    }

    static func postImageMedia(url: URL, image: UIImage) -> Promise<String> {
        return RequestManager.postImageMedia(url: url, image: image)
    }

    static func uploadComment(url: URL, restaurant: Restaurant, comment: Comment) -> Promise<Comment> {
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

        return RequestManager.postRequest(url: url, parameters: parameters, encoding: URLEncoding.queryString).then(execute: { (result: [String:Any]) -> Comment in
            guard let comment = Comment(JSON: result) else {
                throw RequestManagerError.jsonError
            }
            restaurant.addComment(newComment: comment)
            return comment
        })
    }
}
