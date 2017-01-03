//
//  Constantes.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

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
