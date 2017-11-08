//
//  SecurityServices.swift
//  VegoResto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import JWT
import Keys

class SecurityServices: NSObject {

    static let shared: SecurityServices = SecurityServices()

    func getToken() -> String {
        let claims: [String:Any] = [
            "iat": Date().timeIntervalSince1970,
            "iss": APIConfig.apiClientIss
        ]
        let headers: [String:String] = [
            "kid": APIConfig.apiClientId
        ]
        let token = JWT.encode(claims: claims, algorithm: .hs256(APIConfig.apiClientSecret.data(using: .utf8)!), headers: headers)

        return token
    }

}
