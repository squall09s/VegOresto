//
//  RechercheViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MGSwipeTableCell


class RechercheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var varIB_searchBar: UISearchBar!
    @IBOutlet weak var varIB_tableView: UITableView!


    let TAG_CELL_LABEL_NAME = 501
    let TAG_CELL_LABEL_ADRESS = 502
    let TAG_CELL_LABEL_DISTANCE = 505
    let TAG_CELL_LABEL_VILLE = 506

    let TAG_CELL_VIEW_CATEGORIE_COLOR = 510
    let TAG_CELL_IMAGE_FAVORIS = 520

    var array_restaurants: [Restaurant] = UserData.sharedInstance.getRestaurants()

    override func viewDidLoad() {
        super.viewDidLoad()


        self.varIB_searchBar.backgroundImage = UIImage()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        switch StoryboardSegue.Main(rawValue: segue.identifier! )! {

        case .Segue_to_detail:
            // Prepare for your custom segue transition

            if let detailRestaurantVC: DetailRestaurantViewController = segue.destinationViewController as? DetailRestaurantViewController {

                if let index = self.varIB_tableView.indexPathForSelectedRow?.row {

                    detailRestaurantVC.current_restaurant = self.array_restaurants[index]
                }

            }
        }



    }





    // MARK: UITableViewDelegate Delegate



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let current_restaurant: Restaurant = self.array_restaurants[indexPath.row]


        let reuseIdentifier = current_restaurant.favoris.boolValue ? "cell_restaurant_identifer_favoris_on" : "cell_restaurant_identifer_favoris_off"

        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? MGSwipeTableCell



        if cell == nil {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)

        }

        var imageSwipe: UIImage

        if current_restaurant.favoris.boolValue == false {

            switch current_restaurant.categorie() {

            case CategorieRestaurant.Vegan :
                imageSwipe = UIImage.Asset.Img_favoris_on_0.image

            case CategorieRestaurant.Végétarien :
                imageSwipe = UIImage.Asset.Img_favoris_on_1.image

            case CategorieRestaurant.Traditionnel :
                imageSwipe = UIImage.Asset.Img_favoris_on_2.image

            }

        } else {

            imageSwipe = UIImage.Asset.Img_favoris_off.image
        }

        let bt1 = MGSwipeButton(title: "", icon: imageSwipe, backgroundColor: COLOR_GRIS_BACKGROUND ) { (cell) -> Bool in

            current_restaurant.favoris = !(current_restaurant.favoris.boolValue)

            self.varIB_tableView.reloadData()

            return true
        }


        bt1.buttonWidth = 110

        if let _cell = cell {
            _cell.rightButtons = [ bt1 ]

            _cell.rightSwipeSettings.transition = MGSwipeTransition.Static
            _cell.rightSwipeSettings.offset = 0
            _cell.rightSwipeSettings.threshold = 10
            _cell.rightExpansion.buttonIndex = 0
            _cell.rightExpansion.fillOnTrigger = true

        }

        // Configure the cell...



        let label_name = cell?.viewWithTag(TAG_CELL_LABEL_NAME) as? UILabel
        let label_adress = cell?.viewWithTag(TAG_CELL_LABEL_ADRESS) as? UILabel
        let label_distance = cell?.viewWithTag(TAG_CELL_LABEL_DISTANCE) as? UILabel
        let label_ville = cell?.viewWithTag(TAG_CELL_LABEL_VILLE) as? UILabel

        label_name?.text = current_restaurant.name
        label_adress?.text = current_restaurant.address
        label_ville?.text = current_restaurant.ville

        if let view_color_categorie = cell?.viewWithTag(TAG_CELL_VIEW_CATEGORIE_COLOR) {

            switch current_restaurant.categorie() {

            case CategorieRestaurant.Vegan :
                view_color_categorie.backgroundColor = COLOR_VERT

            case CategorieRestaurant.Végétarien :
                view_color_categorie.backgroundColor = COLOR_VIOLET

            case CategorieRestaurant.Traditionnel :
                view_color_categorie.backgroundColor = COLOR_BLEU

            }
        }

        if current_restaurant.favoris.boolValue {

            if let imageview_favoris = cell?.viewWithTag(TAG_CELL_IMAGE_FAVORIS) as? UIImageView {

                switch current_restaurant.categorie() {

                case CategorieRestaurant.Vegan :
                    imageview_favoris.image = UIImage.Asset.Img_favoris_0.image

                case CategorieRestaurant.Végétarien :
                    imageview_favoris.image = UIImage.Asset.Img_favoris_1.image

                case CategorieRestaurant.Traditionnel :
                    imageview_favoris.image = UIImage.Asset.Img_favoris_2.image

                }


            }


        }



        label_distance?.text = ""

        if let distance: Double = current_restaurant.distance {

            if distance > 0 {

                if distance < 1000 {

                    label_distance?.text = String(Int(distance)) + " m"

                } else {

                    label_distance?.text = String(format: "%.1f Km", distance/1000.0 )

                }

            }

        }

        return cell!

    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.array_restaurants.count
    }




    // MARK: UISearchBar Delegate


    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

        let textField: UITextField? = self.findTextFieldInView( searchBar)

        if let _textField = textField {
            _textField.enablesReturnKeyAutomatically = false
        }


    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {

        searchBar.resignFirstResponder()

        return true
    }


    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        self.loadRestaurantsWithWord(searchText)
        self.varIB_tableView?.reloadData()
    }


    func searchBarSearchButtonClicked(searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {

        self.loadRestaurantsWithWord(nil)
        self.varIB_tableView?.reloadData()
    }

    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {

        searchBar.resignFirstResponder()

    }



    func findTextFieldInView(view: UIView) -> UITextField? {

        if view.isKindOfClass(UITextField) {

            return view as? UITextField

        }


        for subview: UIView in view.subviews {

            let textField: UITextField? = self.findTextFieldInView(subview)

            if let _textField = textField {

                return _textField

            }

        }

        return nil

    }



    func loadRestaurantsWithWord(key: String?) {

        self.array_restaurants = UserData.sharedInstance.getRestaurants()

        if let _key = key {

            if _key.characters.count > 3 {

                self.array_restaurants = self.array_restaurants.flatMap({ (current_restaurant: Restaurant) -> Restaurant? in


                    if let clean_name: String = current_restaurant.name?.stringByFoldingWithOptions( .DiacriticInsensitiveSearch, locale: .currentLocale() ) {

                        if clean_name.containsString(_key) {
                            return current_restaurant
                        }


                    }


                    if let clean_adress: String = current_restaurant.address?.stringByFoldingWithOptions( .DiacriticInsensitiveSearch, locale: .currentLocale() ) {

                        if clean_adress.containsString(_key) {
                            return current_restaurant
                        }
                    }


                    return nil


                })

            }

        }


    }


    func update_resultats_for_user_location() {

        if let location = UserData.sharedInstance.location {

            for restaurant in self.array_restaurants {

                restaurant.update_distance_avec_localisation( location )

            }

            self.array_restaurants.sortInPlace({ (restaurantA, restaurantB) -> Bool in

                restaurantA.distance < restaurantB.distance

            })

            self.varIB_tableView.reloadData()

            self.varIB_tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)



        }

    }


}
