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

}
