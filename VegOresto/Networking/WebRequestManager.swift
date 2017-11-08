//
//  ContractManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation
import PromiseKit

class WebRequestManager {
    static let shared = WebRequestManager()

    private func getUrl(_ path: String) -> URL {
        return APIConfig.apiBaseUrl.appendingPathComponent(path)
    }

    public func listComments(restaurant: Restaurant) -> Promise<[Comment]> {
        let url = getUrl("/wp-json/wp/v2/comments?post=\(restaurant.identifier?.intValue ?? 0)")
        return WebRequestServices.listComments(url: url).then(execute: { (comments: [Comment]) -> [Comment] in
            // remove old comments
            for comment in restaurant.getCommentsAsArray() ?? [] {
                UserData.sharedInstance.managedContext.delete(comment)
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

    public func listRestaurants() -> Promise<[Restaurant]> {
        let url = getUrl("/wp-json/vg/v1/restos.json")
        return WebRequestServices.listRestaurants(url: url)
    }

 func postImageMedia( image: UIImage,
                      success: @escaping (String) -> Void,
                      failure: @escaping (Error?) -> Void ) {

    let urlPath = APIConfig.apiBaseUrl.appendingPathComponent("/wp-json/vegoresto/v1/media")
    WebRequestServices.postImageMedia(urlPath: urlPath.absoluteString, image: image, success: { (identImageResult) in

        success(identImageResult)

    }, failure: failure)

    }

    public func loadHoraires() -> Promise<[Horaire]> {
        let url = getUrl("/wp-content/cache/horaires.json")
        return WebRequestServices.loadHoraires(url: url)
    }

    func uploadComment(restaurant: Restaurant, comment: Comment,
                              success: @escaping (Comment) -> Void,
                              failure: @escaping (Error?) -> Void) {

        let urlPath = APIConfig.apiBaseUrl.appendingPathComponent("/wp-json/vegoresto/v1/comments")
        WebRequestServices.uploadComment(urlPath: urlPath.absoluteString, restaurant: restaurant, comment: comment, success: { (resultComment) in

            success(resultComment)

        }) { (error) in

            failure(error)

        }

    }

}
