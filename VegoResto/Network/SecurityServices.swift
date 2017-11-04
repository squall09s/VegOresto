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

        let token = JWT.encode(claims: ["iat": Date().timeIntervalSince1970, "iss": "https://vegoresto.l214.in"], algorithm: .hs256(keyHolder.sECRET_CLIENT_PREPROD.data(using: .utf8)!), headers: [ "kid": "k171000" ] )

        return token
    }

}
