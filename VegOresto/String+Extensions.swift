//
//  String+Extensions.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/18/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation

extension String {
    public func removingHTMLEntities() -> String {
        return self.withCString { (srcPtr: UnsafePointer<CChar>) -> String in
            let len = Int(strlen(srcPtr))
            
            // destination pointer
            let destPtr = UnsafeMutablePointer<CChar>.allocate(capacity: len + 1)
            
            // convert HTML entities
            if decode_html_entities_utf8(destPtr, srcPtr) <= 0 {
                return self
            }
            
            // convert to String
            let destStr = String(utf8String: destPtr)
            
            // dealloc
            destPtr.deallocate(capacity: len + 1)
            
            return destStr ?? self
        }
    }
    
    public func removingHTMLTags() -> String {
        var strResult = self
        strResult = strResult.replacingOccurrences(of: "<br />", with: "")
        strResult = strResult.replacingOccurrences(of:"<p>", with: "")
        strResult = strResult.replacingOccurrences(of:"</p>", with: "")
        
        return strResult.removingHTMLEntities()
    }
}
