//
//  Constantes.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import Alamofire
import Keys

/// Device check

/// Device check
struct Device {

    static let WIDTH   = UIScreen.main.bounds.size.width
    static let HEIGHT    = UIScreen.main.bounds.size.height
    private static let maxLength = max(WIDTH, HEIGHT)
    private static let minLength = min(WIDTH, HEIGHT)

    static let IS_IPHONE_4 = ( Double( UIScreen.main.bounds.height) == Double(480.0) )
    static let IS_IPHONE_5 = ( Double( UIScreen.main.bounds.height) == Double(568.0) )
    static let IS_IPHONE_6 = ( Double( UIScreen.main.bounds.height) == Double(667.0) )
    static let IS_IPHONE_6_PLUS = ( Double( UIScreen.main
        .bounds.height) == Double(736.0) )

    static let IS_IPAD      = UIDevice.current.userInterfaceIdiom == .pad && maxLength == 1024.0
    static let IS_IPAD_PRO   = UIDevice.current.userInterfaceIdiom == .pad && maxLength == 1366.0
    static let IS_TV      = UIDevice.current.userInterfaceIdiom == .tv
}

struct Debug {

    /**
     Methode permettant de réaliser des Logs uniquement en Debug via l'instruction Debug.log("mon log")

     :param: le message
     :returns: void
     */

    static func log(object: Any) {
        if _isDebugAssertConfiguration() {
            Swift.print("DEBUG", object)
        }
    }
}

let COLOR_ORANGE: UIColor = UIColor(hexString: "F79F21")
let COLOR_BLEU: UIColor = UIColor(hexString: "37A8DA")
let COLOR_VERT: UIColor = UIColor(hexString: "70B211")
let COLOR_VIOLET: UIColor = UIColor(hexString: "D252B9")
let COLOR_GRIS_BACKGROUND: UIColor = UIColor(hexString: "EDEDED")
let COLOR_GRIS_FONCÉ: UIColor = UIColor(hexString: "898989")

let KEY_LAST_SYNCHRO = "DateLastShynchro"
let INTERVAL_REFRESH_DATA: Int = 60*60 // byWeek = 24*60*60*7

struct APIConfig {
    static var apiBaseUrl: URL {
        return URL(string: VegOrestoKeys().apiBaseUrl)!
    }

    static var apiClientId: String {
        return VegOrestoKeys().apiClientId
    }

    static var apiClientSecret: String {
        return VegOrestoKeys().apiClientSecret
    }

    static var apiClientIss: String {
        return "\(apiBaseUrl.scheme!)://\(apiBaseUrl.host!)"
    }
}
