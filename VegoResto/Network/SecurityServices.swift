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
        let keyHolder = VegoRestoKeys()

        let claims: [String:Any] = [
            "iat": Date().timeIntervalSince1970,
            "iss": "https://vegoresto.l214.in"
        ]
        let headers: [String:Any] = [
            "kid": keyHolder.apiClientId
        ]
        let token = JWT.encode(claims: claims, algorithm: .hs256(keyHolder.apiClientSecret.data(using: .utf8)!), headers: headers)

        return token
    }

}
