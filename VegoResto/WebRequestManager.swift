//
//  ContractManager.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation

class WebRequestManager {

    static let shared = WebRequestManager()

    func listComment(  restaurant: Restaurant?,
                       success: @escaping ([Comment]) -> Void,
                       failure: @escaping (Error?) -> Void) {

        let urlPath = URL_SERVEUR() + "/wp-json/wp/v2/comments?post=" + String(restaurant?.identifier?.intValue ?? 0)

        WebRequestServices.listComment(urlPath: urlPath, success: { (listComment) in

            for comment: Comment in restaurant?.getCommentsAsArray() ?? [] {

                UserData.sharedInstance.managedContext.delete(comment)
            }

            for comment in listComment as [Comment] {

                restaurant?.addComment(newComment: comment)
            }

            success(listComment)

        }) { (error) in

            failure(error)

        }

    }

}
