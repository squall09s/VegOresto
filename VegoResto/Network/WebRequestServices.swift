//
//  ContractServices.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation
import ObjectMapper

class WebRequestServices {

    static func listComment(urlPath: String,
                            success: @escaping ([Comment]) -> Void,
                             failure: @escaping (Error?) -> Void) {

        RequestManager.doRequest(method: .get,
                                 path: urlPath,
                                 completion: { _resultComment in

                                    success(_resultComment)

        }, failure: failure)

    }

    static func listRestaurant(urlPath: String,
                               success: @escaping ([Restaurant]) -> Void,
                               failure: @escaping (Error?) -> Void) {

        RequestManager.doRequestListGzipped(method: .get, path: urlPath, completion: { (result : [String : Any]) in

            var listRestaurant = [Restaurant]()

            for (_, dico) in result {

                if let _dicoJSON = dico as? [String : Any] {

                    if let currentRestau : Restaurant = UserData.sharedInstance.getRestaurantWithIdentifier(identifier:

                    (_dicoJSON["id"] as? NSNumber )?.intValue ?? -1 ) {

                        currentRestau.mapping(map: Map(mappingType: .fromJSON, JSON: _dicoJSON))
                        listRestaurant.append( currentRestau )

                    } else {

                        if let _newRestaurant = Restaurant(JSON: _dicoJSON) {
                            listRestaurant.append( _newRestaurant )
                        }
                    }

                }
            }

            do {
                try UserData.sharedInstance.managedContext.save()
            } catch {

                let nserror = error as NSError
                Debug.log(object: "listRestaurant : saveContext - Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }

            success(listRestaurant)

        }, failure: failure)

    }

    static func loadHoraires(urlPath: String,
                             success: @escaping () -> Void,
                             failure: @escaping (Error?) -> Void) {

        RequestManager.doRequestList(method: .get, path: urlPath, completion: { (result : [String : Any]) in

            var listHoraire = [Horaire]()

            for (_, dico) in result {

                if let _dicoJSON = dico as? [String : Any] {

                    if let _newHoraire = Horaire(JSON: _dicoJSON) {
                        listHoraire.append( _newHoraire )
                    }
                }
            }

            success()

        }, failure: failure)

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
