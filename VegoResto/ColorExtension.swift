//
//  ColorExtension.swift
//  ManageColabApps
//
//  Created by Laurent Nicolas on 21/10/2015.
//  Copyright © 2015 sopra. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hexString: String) {
        // Trim leading '#' if needed
        let cleanedHexString = hexString

        // String -> UInt32
        var rgbValue: UInt32 = 0
        Scanner(string: cleanedHexString).scanHexInt32(&rgbValue)

        // UInt32 -> R,G,B
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)

    }
}
