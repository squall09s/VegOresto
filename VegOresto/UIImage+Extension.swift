//
//  UIImage+Extension.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/9/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation

extension UIImage {
    public func jpegRepresentation(sizeLimit: Int) -> Data? {
        for i in 0...9 {
            if let imageData = UIImageJPEGRepresentation(self, 1.0 - (0.1 * CGFloat(i))), imageData.count < sizeLimit {
                return imageData
            }
        }
        return nil
    }
}
