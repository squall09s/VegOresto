//
//  AnalyticsHelper.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 12/15/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class AnalyticsHelper {
    static let shared = AnalyticsHelper()
    
    var restaurantSearchWorkItem: DispatchWorkItem?
    
    public func eventRestaurantSearch(searchText: String) {
        if searchText.isEmpty {
            return
        }

        restaurantSearchWorkItem?.cancel()
        restaurantSearchWorkItem = DispatchWorkItem {
            self.logEvent(AnalyticsEventSearch, parameters: [
                AnalyticsParameterContentType: "restaurant",
                AnalyticsParameterSearchTerm: searchText,
            ])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: restaurantSearchWorkItem!)
    }

    public func eventRestaurantView(restaurant: Restaurant) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        
        let category = restaurant.category
        
        logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: (category == .Vegan ? "vegan" : (category == .Végétarien ? "vegetarian" : "veganfriendly")),
        ])
    }
    
    private func logEvent(_ eventName: String, parameters: [String:Any]) {
        Debug.log(object: "Analytics Event \"\(eventName)\": \(String(data: try! JSONSerialization.data(withJSONObject: parameters, options: []), encoding: .utf8)!)")
        Analytics.logEvent(eventName, parameters: parameters)
    }
}
