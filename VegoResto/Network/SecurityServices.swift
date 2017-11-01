//
//  SecurityServices.swift
//  VegoResto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import JWT

class SecurityServices: NSObject {

    static let shared: SecurityServices = SecurityServices()

    func getToken() -> String {

       // JWT.encode(claims: ["iat": Date(), "iss": "https://vegoresto.l214.in"], keyID: "k171000",algorithm: .hs256())

        let token = JWT.encode(claims: ["iat": Date().timeIntervalSince1970, "iss": "https://vegoresto.l214.in"], algorithm: .hs256("Bei5ulohTe0bou5Xai6wahGhah6he6".data(using: .utf8)!), headers: [ "kid": "k171000" ] )

        return token
    }

}
