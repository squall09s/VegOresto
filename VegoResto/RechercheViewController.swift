//
//  RechercheViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class RechercheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var varIB_searchBar: UISearchBar!
    @IBOutlet weak var varIB_tableView: UITableView!


    let TAG_CELL_LABEL_NAME = 501
    let TAG_CELL_LABEL_ADRESS = 502
    let TAG_CELL_LABEL_DISTANCE = 505
    let TAG_CELL_LABEL_VILLE = 506

    let TAG_CELL_VIEW_CATEGORIE_COLOR = 510

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

        let reuseIdentifier = "cell_restaurant_identifer"

        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)

        if cell == nil {

            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)

        }


        let current_restaurant: Restaurant = self.array_restaurants[indexPath.row]

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
