//
//  ContractServices.swift
//  TestIntegration
//
//  Created by Nicolas LAURENT on 29/06/2017.
//  Copyright © 2017 NicolasLAURENT. All rights reserved.
//

import Foundation

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

        RequestManager.doRequestList(method: .get, path: urlPath, completion: { (result : [String : Any]) in

            var listRestaurant = [Restaurant]()

            for (_, dico) in result {

                if let _dicoJSON = dico as? [String : Any] {

                    if let _newRestaurant = Restaurant(JSON: _dicoJSON) {
                        listRestaurant.append( _newRestaurant )
                    }
                }
            }

            success(listRestaurant)

        }, failure: failure)

    }

}
