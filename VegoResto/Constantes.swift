//
//  Constantes.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit


/// Device check
struct Device {

    static let LARGEUR   = UIScreen.mainScreen().bounds.size.width
    static let HAUTEUR    = UIScreen.mainScreen().bounds.size.height
    private static let maxLength = max(LARGEUR, HAUTEUR)
    private static let minLength = min(LARGEUR, HAUTEUR)

    static let IS_IPHONE_4 = ( Double( UIScreen.mainScreen().bounds.height) == Double(480.0) )
    static let IS_IPHONE_5 = ( Double( UIScreen.mainScreen().bounds.height) == Double(568.0) )
    static let IS_IPHONE_6 = ( Double( UIScreen.mainScreen().bounds.height) == Double(667.0) )
    static let IS_IPHONE_6_PLUS = ( Double( UIScreen.mainScreen().bounds.height) == Double(736.0) )

    static let IS_IPAD      = UIDevice.currentDevice().userInterfaceIdiom == .Pad && maxLength == 1024.0
    static let IS_IPAD_PRO   = UIDevice.currentDevice().userInterfaceIdiom == .Pad && maxLength == 1366.0
    static let IS_TV      = UIDevice.currentDevice().userInterfaceIdiom == .TV
}


func runAfterDelay (delay: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
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
