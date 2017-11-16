//
//  CLLocation+Extensions.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 11/16/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    public var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    public func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return location.distance(from: coordinate.location)
    }
}
