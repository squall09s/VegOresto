//
//  AnalyticsHelper.swift
//  VegOresto
//
//  Created by Micha Mazaheri on 12/15/17.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum RestaurantListType {
    case search
    case map
    
    var logString: String {
        switch self {
        case .search:
            return "search"
        case .map:
            return "map"
        }
    }
}

enum AnalyticsMapBrand {
    case apple
    case google
    
    var logString: String {
        switch self {
        case .apple:
            return "apple"
        case .google:
            return "google"
        }
    }
}

enum AnalyticsContactMedia {
    case phone
    case email
    case facebook
    case website

    var logString: String {
        switch self {
        case .phone:
            return "phone"
        case .email:
            return "email"
        case .facebook:
            return "facebook"
        case .website:
            return "website"
        }
    }
}

class AnalyticsHelper {
    static let shared = AnalyticsHelper()
    
    var restaurantSearchWorkItem: DispatchWorkItem?
    var restaurantListCategoryWorkItem: DispatchWorkItem?
    
    // MARK: Events
    
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

    public func eventRestaurantList(categories: Set<CategorieRestaurant>, listType: RestaurantListType, hasLocation: Bool) {
        restaurantListCategoryWorkItem?.cancel()
        restaurantListCategoryWorkItem = DispatchWorkItem {
            self.logEvent(AnalyticsEventViewItemList, parameters: [
                AnalyticsParameterItemCategory: categories.map({ (category) -> String in
                    return self.getRestaurantCategory(category)
                }).sorted().joined(separator: ","),
                "list_type": listType.logString,
                "location": (hasLocation ? "enabled" : "disabled"),
            ])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: restaurantListCategoryWorkItem!)
    }

    public func eventRestaurantView(restaurant: Restaurant) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
        ])
    }
    
    public func eventRestaurantCommentsView(restaurant: Restaurant) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        logEvent("view_item_comments", parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
        ])
    }
    
    public func eventRestaurantAddToFavorites(restaurant: Restaurant) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name, restaurant.favoris.boolValue else {
            return
        }
        logEvent(AnalyticsEventAddToWishlist, parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
        ])
    }
    
    public func eventRestaurantOpenMaps(restaurant: Restaurant, mapBrand: AnalyticsMapBrand) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        logEvent("view_item_map", parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
            "map_brand": mapBrand.logString,
        ])
    }
    
    public func eventRestaurantShare(restaurant: Restaurant) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        logEvent("view_item_share", parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
        ])
    }
    
    public func eventRestaurantContact(restaurant: Restaurant, media: AnalyticsContactMedia) {
        guard let identifier = restaurant.identifier?.intValue, let name = restaurant.name else {
            return
        }
        logEvent("view_item_contact", parameters: [
            AnalyticsParameterItemID: String(identifier),
            AnalyticsParameterItemName: name,
            AnalyticsParameterItemCategory: getRestaurantCategory(restaurant.category),
            "contact_media": media.logString,
        ])
    }
    
    // MARK: Helpers
    
    private func logEvent(_ eventName: String, parameters: [String:Any]) {
        Debug.log(object: "Analytics Event \"\(eventName)\": \(String(data: try! JSONSerialization.data(withJSONObject: parameters, options: []), encoding: .utf8)!)")
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    private func getRestaurantCategory(_ category: CategorieRestaurant) -> String {
        switch category {
        case .Vegan:
            return "vegan"
        case .Végétarien:
            return "vegetarian"
        case .VeganFriendly:
            return "veganfriendly"
        }
    }
}
