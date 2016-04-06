//
//  RechercheViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class RechercheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    
    @IBOutlet weak var varIB_searchBar: UISearchBar!
    
    
    @IBOutlet weak var varIB_tableView: UITableView!
    
    
    let TAG_CELL_LABEL_NAME = 501
    let TAG_CELL_LABEL_ADRESS = 502
    
    let TAG_CELL_IMAGEVIEW_VEGAN = 503
    let TAG_CELL_IMAGEVIEW_GLUTEN = 504
    
    var array_restaurants : [Restaurant] = UserData.sharedInstance.getRestaurants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segue_to_detail" {
            
            if let detailRestaurantVC : DetailRestaurantViewController = segue.destinationViewController as? DetailRestaurantViewController {
                
                if let index = self.varIB_tableView.indexPathForSelectedRow?.row{
                    
                    detailRestaurantVC.current_restaurant = self.array_restaurants[index]
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    // MARK: UITableViewDelegate Delegate
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "cell_restaurant_identifer"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        
        if cell == nil
        {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
            
        }
        
        
        let current_restaurant : Restaurant = self.array_restaurants[indexPath.row]
        
        let label_name = cell?.viewWithTag(TAG_CELL_LABEL_NAME) as? UILabel
        let label_adress = cell?.viewWithTag(TAG_CELL_LABEL_ADRESS) as? UILabel
        
        
        label_name?.text = current_restaurant.name
        label_adress?.text = current_restaurant.address
        
        
        
        let tags_presents = current_restaurant.tags_are_present()
        
    
        if let imageview_vegan = cell?.viewWithTag(TAG_CELL_IMAGEVIEW_VEGAN) as? UIImageView{
            
            imageview_vegan.image = UIImage(named: tags_presents.is_vegan ?         "img_vegan_on"          :  "img_vegan_off")
        }
        
        
        if let imageview_gluten = cell?.viewWithTag(TAG_CELL_IMAGEVIEW_GLUTEN) as? UIImageView{
        
            imageview_gluten.image = UIImage(named: tags_presents.is_gluten_free ?   "img_gluten_free_on"   :  "img_gluten_free_off")
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
        
        let textField : UITextField? = self.findTextFieldInView( searchBar)
        
        if let _textField = textField{
            _textField.enablesReturnKeyAutomatically = false
        }
        
        
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool{
        
        searchBar.resignFirstResponder()
        
        return true
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        self.loadRestaurantsWithWord(searchText)
        self.varIB_tableView?.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        
        self.loadRestaurantsWithWord(nil)
        self.varIB_tableView?.reloadData()
    }
    
    func searchBarResultsListButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        
    }
    
    
    
    func findTextFieldInView(view : UIView)  -> UITextField? {
        
        if view.isKindOfClass(UITextField) {
            
            return view as? UITextField
            
        }
        
        
        for subview : UIView in view.subviews {
            
            let textField : UITextField? = self.findTextFieldInView(subview)
            
            if let _textField = textField {
                
                return _textField
                
            }
            
        }
        
        return nil
        
    }
    
    
    
    
    func loadRestaurantsWithWord(key : String?){
        
        self.array_restaurants = UserData.sharedInstance.getRestaurants()
        
        if let _key = key {
            
            if _key.characters.count > 3 {
            
            self.array_restaurants = self.array_restaurants.flatMap({ (current_restaurant : Restaurant) -> Restaurant? in
                
                
                if let name = current_restaurant.name {
                    
                    if name.containsString(_key){
                        return current_restaurant
                    }
                    
                }
                
                if let adress = current_restaurant.address {
                    
                    if adress.containsString(_key){
                        return current_restaurant
                    }
                    
                }
                
                return nil
                
                
            })
                
            }
            
        }
        
        
    }
    
    
}
