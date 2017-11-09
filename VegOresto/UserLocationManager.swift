//
//  UserLocationManager.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/9/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, CLLocationManagerDelegate {

    static public let shared = UserLocationManager()
    private var locationmanager: CLLocationManager
    public var location: CLLocationCoordinate2D?

    private override init() {
        locationmanager = CLLocationManager()
        super.init()
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        locationmanager.delegate = self
    }

    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationmanager.stopUpdatingLocation()
        Debug.log(object: error)
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var isLocationAllowed = false

        switch status {
        case CLAuthorizationStatus.restricted:
            Debug.log( object: "Restricted Access to location")
        case CLAuthorizationStatus.denied:
            Debug.log( object: "User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            Debug.log( object: "Status not determined")
        default:
            Debug.log( object: "Allowed to location Access")
            isLocationAllowed = true
        }

        if isLocationAllowed == true {
            Debug.log(object: "Location to Allowed")
            locationmanager.startUpdatingLocation()
        }
    }
}
