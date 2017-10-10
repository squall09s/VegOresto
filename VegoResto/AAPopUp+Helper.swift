//
//  AAPopUp+Helper.swift
//  AAPopUp
//
//  Created by Engr. Ahsan Ali on 12/29/2016.
//  Copyright (c) 2016 AA-Creations. All rights reserved.
//

// MARK: - AAPopUps
class AAPopUps<S, V, W, X>: AAPopUp {

    let _storyboard: String?
    let _id: String
    let _currentComment: Comment?
    let _currentRestaurant: Restaurant?

    public init(_ storyboard: String? = nil, identifier: String, currentComment: Comment?, currentRestaurant: Restaurant?) {
        self._storyboard = storyboard
        self._id = identifier
        self._currentComment = currentComment
        self._currentRestaurant = currentRestaurant
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

/// AAPopUp options
class AAPopUpOptions: NSObject {

     var storyboardName: String?
     var dismissTag: Int?
     var cornerRadius: CGFloat = 4.0
     var animationDuration = 0.2
     var backgroundColor = UIColor.black.withAlphaComponent(0.7)

}

// MARK: - AAPopUp helper
extension AAPopUp {

    /// Get view controller from given AAPopUps object
    ///
    /// - Parameter popup: AAPopUps object
    /// - Returns: UIViewController
    func getViewController(_ popup: AAPopUps<String?, String, Comment?, Restaurant?>) -> UIViewController {

        var storyboard_id: String!
        if let storyboard = popup._storyboard {
            storyboard_id = storyboard
        } else if let storyboard = options.storyboardName {
            storyboard_id = storyboard
        } else {
            fatalError("AAPopUp - Invalid Storyboard name. Aborting ...")
        }

        let storyboard: UIStoryboard = UIStoryboard(name: storyboard_id, bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: popup._id)

        self.currentComment = popup._currentComment
        self.currentRestaurant = popup._currentRestaurant

        return vc
    }
}
