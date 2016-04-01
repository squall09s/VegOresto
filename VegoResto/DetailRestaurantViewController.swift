//
//  DetailRestaurantViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class DetailRestaurantViewController: UIViewController {

    @IBOutlet weak var varIB_label_name: UILabel!
    
    var current_restaurant : Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let _current_restaurant =  self.current_restaurant {
            
           self.varIB_label_name.text = _current_restaurant.name
            
        }else{
            
            UIAlertView(title: "Error", message: "Aucun restaurant trouvé", delegate: nil, cancelButtonTitle: "ok", otherButtonTitles: "").show()
            
        
            
           // UIAlertController(title: "Error", message: "Aucun restaurant trouvé.", preferredStyle: UIAlertControllerStyle.Alert).pr
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func touch_bt_back(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true) { 
            
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
