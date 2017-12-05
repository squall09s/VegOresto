//
//  RechercheViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import DGElasticPullToRefresh

class RechercheViewController: VGAbstractFilterViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var varIB_searchBar: UISearchBar?
    @IBOutlet weak var varIB_tableView: UITableView?

    var afficherUniquementFavoris = false

    let TAG_CELL_LABEL_NAME = 501
    let TAG_CELL_LABEL_ADRESS = 502
    let TAG_CELL_LABEL_DISTANCE = 505
    let TAG_CELL_LABEL_VILLE = 506
    let TAG_CELL_IMAGE_LOC = 507

    let TAG_CELL_VIEW_CATEGORIE_COLOR = 510
    let TAG_CELL_IMAGE_FAVORIS = 520
    
    let TAG_CELL_STAR_1 = 581
    let TAG_CELL_STAR_2 = 582
    let TAG_CELL_STAR_3 = 583
    let TAG_CELL_STAR_4 = 584
    let TAG_CELL_STAR_5 = 585

    var array_restaurants = [Restaurant]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.varIB_searchBar?.backgroundImage = UIImage()

        self.loadRestaurants()

        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = COLOR_ORANGE
        self.varIB_tableView?.dg_addPullToRefreshWithActionHandler({ () -> Void in
            (self.parent as? NavigationAccueilViewController)?.updateData(forced: true).always {
                self.varIB_tableView?.dg_stopLoading()
            }
        }, loadingView: loadingView)

        self.varIB_tableView?.dg_setPullToRefreshFillColor( UIColor(hexString: "EDEDED") )
        self.varIB_tableView?.dg_setPullToRefreshBackgroundColor(UIColor.white)
    }

    private func findTextFieldInView(view: UIView) -> UITextField? {

        if view is UITextField {

            return view as? UITextField

        }

        for subview: UIView in view.subviews {

            let textField: UITextField? = self.findTextFieldInView(view: subview)

            if let _textField = textField {

                return _textField

            }

        }

        return nil

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch StoryboardSegue.Main(rawValue: segue.identifier! )! {

        case .segueToDetail:
            // Prepare for your custom segue transition

            if let detailRestaurantVC: DetailRestaurantViewController = segue.destination as? DetailRestaurantViewController {

                if let index = self.varIB_tableView?.indexPathForSelectedRow?.row {

                    detailRestaurantVC.current_restaurant = self.array_restaurants[index]
                }

            }

        default :
            break
        }

    }

    // MARK: UITableViewDelegate Delegate
    
    private func setStarRating(rating: Double, cell: UITableViewCell) {
        let image_rating_1 = cell.viewWithTag(TAG_CELL_STAR_1) as? UIImageView
        let image_rating_2 = cell.viewWithTag(TAG_CELL_STAR_2) as? UIImageView
        let image_rating_3 = cell.viewWithTag(TAG_CELL_STAR_3) as? UIImageView
        let image_rating_4 = cell.viewWithTag(TAG_CELL_STAR_4) as? UIImageView
        let image_rating_5 = cell.viewWithTag(TAG_CELL_STAR_5) as? UIImageView
        
        if rating == 0.5 {
            image_rating_1?.image = Asset.imgFavorisStarHalf.image
        } else if rating > 0.5 {
            image_rating_1?.image = Asset.imgFavorisStarOn.image
        } else {
            image_rating_1?.image = Asset.imgFavorisStarOff.image
        }
        
        if rating == 1.5 {
            image_rating_2?.image = Asset.imgFavorisStarHalf.image
        } else if rating > 1.5 {
            image_rating_2?.image = Asset.imgFavorisStarOn.image
        } else {
            image_rating_2?.image = Asset.imgFavorisStarOff.image
        }
        
        if rating == 2.5 {
            image_rating_3?.image = Asset.imgFavorisStarHalf.image
        } else if rating > 2.5 {
            image_rating_3?.image = Asset.imgFavorisStarOn.image
        } else {
            image_rating_3?.image = Asset.imgFavorisStarOff.image
        }
        
        if rating == 3.5 {
            image_rating_4?.image = Asset.imgFavorisStarHalf.image
        } else if rating > 3.5 {
            image_rating_4?.image = Asset.imgFavorisStarOn.image
        } else {
            image_rating_4?.image = Asset.imgFavorisStarOff.image
        }
        
        if rating == 4.5 {
            image_rating_5?.image = Asset.imgFavorisStarHalf.image
        } else if rating > 4.5 {
            image_rating_5?.image = Asset.imgFavorisStarOn.image
        } else {
            image_rating_5?.image = Asset.imgFavorisStarOff.image
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get restaurant
        let current_restaurant = self.array_restaurants[indexPath.row]

        // Get cell
        let reuseIdentifier = current_restaurant.favoris.boolValue ? "cell_restaurant_identifer_favoris_on" : "cell_restaurant_identifer_favoris_off"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MGSwipeTableCell
        if cell == nil {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }

        // Configure the cell...

        let label_name = cell?.viewWithTag(TAG_CELL_LABEL_NAME) as? UILabel
        let label_adress = cell?.viewWithTag(TAG_CELL_LABEL_ADRESS) as? UILabel
        let label_distance = cell?.viewWithTag(TAG_CELL_LABEL_DISTANCE) as? UILabel
        let label_ville = cell?.viewWithTag(TAG_CELL_LABEL_VILLE) as? UILabel
        let image_loc = cell?.viewWithTag(TAG_CELL_IMAGE_LOC) as? UIImageView

        label_name?.text = current_restaurant.name
        label_adress?.text = current_restaurant.address
        label_ville?.text = current_restaurant.displayCityName
        
        // Set rating
        if let _cell = cell {
            let rating = current_restaurant.rating?.doubleValue ?? 1
            setStarRating(rating: rating, cell: _cell)
        }

        let view_color_categorie = cell?.viewWithTag(TAG_CELL_VIEW_CATEGORIE_COLOR)
        let imageview_favoris = cell?.viewWithTag(TAG_CELL_IMAGE_FAVORIS) as? UIImageView

        var imageSwipe: UIImage = Asset.imgFavorisOff.image

        switch current_restaurant.category {

        case CategorieRestaurant.Vegan :
            view_color_categorie?.backgroundColor = COLOR_VERT
            if current_restaurant.favoris.boolValue {
                imageview_favoris?.image = Asset.imgFavoris0.image
            } else {
                imageSwipe = Asset.imgFavorisOn0.image
            }

        case CategorieRestaurant.Végétarien :
            view_color_categorie?.backgroundColor = COLOR_VIOLET
            if current_restaurant.favoris.boolValue {
                imageview_favoris?.image = Asset.imgFavoris1.image
            } else {
                imageSwipe = Asset.imgFavorisOn1.image
            }

        case CategorieRestaurant.VeganFriendly :
            view_color_categorie?.backgroundColor = COLOR_BLEU
            if current_restaurant.favoris.boolValue {
                imageview_favoris?.image = Asset.imgFavoris2.image
            } else {
                imageSwipe = Asset.imgFavorisOn2.image
            }

        }

        let bt1 = MGSwipeButton(title: "", icon: imageSwipe, backgroundColor: COLOR_GRIS_BACKGROUND ) { (_) -> Bool in

            current_restaurant.favoris = !(current_restaurant.favoris.boolValue) as NSNumber

            self.afficherUniquementFavoris ? self.updateData() : self.varIB_tableView?.reloadData()

            return true
        }

        bt1.buttonWidth = 110

        cell?.rightButtons = [ bt1]
        cell?.rightSwipeSettings.transition = .static
        cell?.rightSwipeSettings.threshold = 10
        cell?.rightExpansion.buttonIndex = 0
        cell?.rightExpansion.fillOnTrigger = true

        label_distance?.text = ""
        image_loc?.isHidden = true

        if current_restaurant.distance > 0 && current_restaurant.distance < 1000 {

            label_distance?.text = String(Int(current_restaurant.distance)) + " m"
            image_loc?.isHidden = false

        } else if current_restaurant.distance >= 1000 {

            label_distance?.text = String(format: "%.1f Km", current_restaurant.distance/1000.0 )
            image_loc?.isHidden = false
        }

        return cell!

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.array_restaurants.count
    }

    // MARK: UISearchBar Delegate

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        let textField: UITextField? = self.findTextFieldInView( view: searchBar)

        if let _textField = textField {
            _textField.enablesReturnKeyAutomatically = false
        }

    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.resignFirstResponder()

        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadRestaurants(word: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.loadRestaurants()
    }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }
    
    // MARK: Search

    private func filterByWord(restaurants: [Restaurant], word: String) -> [Restaurant] {
        // no filtering if less than or equal to 3 characters
        if word.count <= 3 {
            return restaurants
        }
        
        let key = word.lowercased()
        
        return restaurants.filter({ (current_restaurant: Restaurant) -> Bool in
            if let clean_name: String = current_restaurant.name?.lowercased().folding(options : .diacriticInsensitive, locale: Locale.current) {
                if clean_name.contains(key) {
                    return true
                }
            }
            if let clean_adress: String = current_restaurant.address?.lowercased().folding(options: .diacriticInsensitive, locale: Locale.current) {
                if clean_adress.contains(key) {
                    return true
                }
            }
            return false
        })
    }
    
    private func loadRestaurants(word: String? = nil) {
        var restaurants = UserData.shared.viewContext.getRestaurants()

        // filter favorites
        if self.afficherUniquementFavoris {
            restaurants = restaurants.filter({ (current_restaurant: Restaurant) -> Bool in
                return current_restaurant.favoris.boolValue
            })
        }
        
        // filter by category
        restaurants = filterCurrentCategories(restaurants: restaurants)
        
        // filter by word
        if let _word = word {
            restaurants = filterByWord(restaurants: restaurants, word: _word)
        }
        
        // sort by distance (or name)
        if let location = UserLocationManager.shared.location {
            for restaurant in restaurants {
                restaurant.setDistance(from: location)
            }
            restaurants.sort(by: { (restaurantA, restaurantB) -> Bool in
                restaurantA.distance < restaurantB.distance
            })
        } else {
            restaurants.sort(by: { (restaurantA, restaurantB) -> Bool in
                (restaurantA.name ?? "").lowercased().folding(options : .diacriticInsensitive, locale: Locale.current) < (restaurantB.name ?? "").lowercased().folding(options : .diacriticInsensitive, locale: Locale.current)
            })
        }
        
        // reload
        self.array_restaurants = restaurants
        self.varIB_tableView?.reloadData()
    }

    func update_resultats_for_user_location() {
        // ask for user authorization
        UserLocationManager.shared.requestAuthorization()

        // wait for location
        UserLocationManager.shared.getLocation().then { (location) -> Void in
            self.updateData()
        }
    }

    override func updateData() {
        self.loadRestaurants(word: self.varIB_searchBar?.text)
        self.varIB_tableView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}

// -----------------------------------------
// MARK: Protocol - UIScrollViewDelegate
// -----------------------------------------

extension RechercheViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 50 {
            self.view.endEditing(true)
        }
    }
}
