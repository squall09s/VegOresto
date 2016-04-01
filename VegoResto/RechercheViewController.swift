//
//  RechercheViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class RechercheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var varIB_tableView: UITableView!
    
    
    let TAG_CELL_LABEL_NAME = 501
    let TAG_CELL_LABEL_ADRESS = 502
    
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
        
        return cell!
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array_restaurants.count
    }
    
}
