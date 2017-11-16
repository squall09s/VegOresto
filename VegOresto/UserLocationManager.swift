//
//  UserLocationManager.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/9/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

struct PendingLocationRequest {
    var fulfill: ((CLLocation) -> Void)
    var reject: ((Error) -> Void)
    init(fulfill: @escaping ((CLLocation) -> Void), reject: @escaping ((Error) -> Void)) {
        self.fulfill = fulfill
        self.reject = reject
    }
}

class UserLocationManager: NSObject, CLLocationManagerDelegate {

    static public let shared = UserLocationManager()
    private var locationmanager: CLLocationManager
    private var pendingRequests: [PendingLocationRequest] = []
    public var location: CLLocation?

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
        rejectPendingRequest(error: error)
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            fulfillPendingRequests(location: location)
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
    
    private func fulfillPendingRequests(location: CLLocation) {
        for request in pendingRequests {
            request.fulfill(location)
        }
        pendingRequests.removeAll()
    }
    
    private func rejectPendingRequest(error: Error) {
        for request in pendingRequests {
            request.reject(error)
        }
        pendingRequests.removeAll()
    }
    
    internal func getLocation() -> Promise<CLLocation> {
        if let location = location {
            return Promise(value: location)
        } else {
            return Promise(resolvers: { (fulfill, reject) in
                self.pendingRequests.append(PendingLocationRequest(fulfill: fulfill, reject: reject))
            })
        }
    }
}
