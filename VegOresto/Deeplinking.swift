//
//  Deeplinking.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/9/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreLocation

class Deeplinking {
    private static func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private static func openURL(_ url: String) {
        if let _url = URL(string: url) {
            openURL(_url)
        }
    }
    private static func canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    private static func canOpenURL(_ url: String) -> Bool {
        guard let _url = URL(string: url) else {
            return false
        }
        return UIApplication.shared.canOpenURL(_url)
    }
    
    // MARK: HTTP
    
    static public func openWebsite(url: String) {
        var cleanUrl = url
        if !cleanUrl.hasPrefix("http") {
            cleanUrl = "http://\(cleanUrl)"
        }
        openURL(cleanUrl)
    }

    // MARK: Email

    static public func openSendEmail(to: String, subject: String? = nil) {
        guard let _subject = subject?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        openURL("mailto:\(to)?subject=" + _subject)
    }
    
    // MARK: Phone
    
    static public func openPhone(phoneNumber: String) {
        var cleanNumber = phoneNumber
        cleanNumber = cleanNumber.replacingOccurrences(of: " ", with: "")
        cleanNumber = cleanNumber.replacingOccurrences(of: ".", with: "")
        openURL("telprompt://\(cleanNumber)")
    }
    
    // MARK: Google Maps
    
    static public func openGoogleMaps(location: CLLocationCoordinate2D) {
        openURL("comgooglemaps://?daddr=\(location.latitude),\(location.longitude)&directionsmode=driving&zoom=14&views=traffic")
    }
    static public func canOpenGoogleMaps() -> Bool {
        return canOpenURL("comgooglemaps://")
    }

    // MARK: Social Media VegOresto

    static public func openFacebookProfile() {
        let facebookAppUrl = URL(string: "fb://profile/854933141235331")!
        let facebookWebUrl = URL(string: "https://www.facebook.com/vegoresto")!
        if UIApplication.shared.canOpenURL(facebookAppUrl) {
            UIApplication.shared.open(facebookAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(facebookWebUrl, options: [:], completionHandler: nil)
        }
    }

    static public func openTwitterProfile() {
        let twitterAppUrl = URL(string: "twitter://user?screen_name=VegOresto")!
        let twitterWebUrl = URL(string: "https://twitter.com/VegOresto")!
        if UIApplication.shared.canOpenURL(twitterAppUrl) {
            UIApplication.shared.open(twitterAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(twitterWebUrl, options: [:], completionHandler: nil)
        }
    }

    static public func openInstagramProfile() {
        let instagramAppUrl = URL(string: "instagram://user?username=vegoresto")!
        let instagramWebUrl = URL(string: "https://www.instagram.com/vegoresto/")!
        if UIApplication.shared.canOpenURL(instagramAppUrl) {
            UIApplication.shared.open(instagramAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instagramWebUrl, options: [:], completionHandler: nil)
        }
    }
}
