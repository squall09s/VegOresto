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
    @IBOutlet weak var varIB_label_adresse : UILabel!
    
    @IBOutlet weak var varIB_label_phone : UILabel!

    
    var current_restaurant : Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        if let _current_restaurant =  self.current_restaurant {
            
           self.varIB_label_name.text = _current_restaurant.name
           self.varIB_label_adresse.text = _current_restaurant.address
            
           self.varIB_label_phone.text = _current_restaurant.phone
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        /*
        let alertController = UIAlertController(title: "Error", message: "Aucun restaurant trouvé.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction( UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil  ) )
        
        self.presentViewController(alertController, animated: true, completion: nil)
        */
        
        
    }
    
    
    @IBAction func touch_bt_back(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true) { 
            
            
        }
        
    }
    
    
    @IBAction func touch_bt_phone(sender: AnyObject) {
        
    
    }
    
    
    @IBAction func touch_bt_maps(sender: AnyObject) {
        
    
    }
    
    @IBAction func touch_bt_site_web(sender: AnyObject) {
    
        
    }
    
    
    @IBAction func touch_bt_more_informations(sender: AnyObject) {
        
        
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
