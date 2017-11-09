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
        return RequestManager.doRequestListGzipped(method: .get, url: url).then { (result : [String : Any]) -> [Restaurant] in
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

    static func postImageMedia(urlPath: String, image: UIImage,
                               success: @escaping (String) -> Void,
                               failure: @escaping (Error?) -> Void ) {

        RequestManager.postImageMedia(path: urlPath, imageMedia: image, parameters: nil, completion: { (identImage) in

            success(identImage)

        }, failure: failure)
    }

    static func uploadComment(urlPath: String, restaurant: Restaurant, comment: Comment,
                              success: @escaping (Comment) -> Void,
                              failure: @escaping (Error?) -> Void) {

        var _urlPathWithParam = urlPath + "?"
        _urlPathWithParam += "&post=" + String(restaurant.identifier?.intValue ?? -1)
        _urlPathWithParam += "&content=" + (comment.content?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")

        if let vote = comment.rating?.intValue {
            if vote > 0 && vote < 6 {
                _urlPathWithParam += "&vote=" + String(vote)
            }
        }

        if let imageComment = comment.temporaryImageIdentSend {
            _urlPathWithParam += "&images=" + imageComment
        }

        if let parentId = comment.parentId?.intValue {
            _urlPathWithParam += "&parent=" + String(parentId)
        }

        _urlPathWithParam += "&author_email=" + (comment.email?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Noname@mail.fr")
        _urlPathWithParam += "&author_name=" + (comment.author?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "Invite")

        RequestManager.postRequest(path: _urlPathWithParam, parameters : nil, completion: { (result: [String : Any])  in

            if let _newComment = Comment(JSON: result) {

                restaurant.addComment(newComment: _newComment)
                success(_newComment)

            }

        }) { (error) in

            failure(error)

        }

    }

}
