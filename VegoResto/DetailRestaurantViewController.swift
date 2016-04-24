//
//  DetailRestaurantViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MapleBacon

class DetailRestaurantViewController: UIViewController {

    @IBOutlet weak var varIB_label_name: UILabel!
    @IBOutlet weak var varIB_label_adresse: UILabel!

    @IBOutlet weak var varIB_label_phone: UILabel!

    @IBOutlet weak var varIB_image_vegan: UIImageView!
    @IBOutlet weak var varIB_image_gluten_free: UIImageView!


    @IBOutlet weak var varIB_image_presentation: UIImageView!

    var current_restaurant: Restaurant? = nil

    override func viewDidLoad() {
        super.viewDidLoad()


        if let _current_restaurant =  self.current_restaurant {

           self.varIB_label_name.text = _current_restaurant.name
           self.varIB_label_adresse.text = _current_restaurant.address

           self.varIB_label_phone.text = _current_restaurant.phone

            let tags_presents = _current_restaurant.tags_are_present()

            varIB_image_vegan?.image = tags_presents.is_vegan ? UIImage.Asset.Img_vegan_on.image : UIImage.Asset.Img_vegan_off_white.image

            varIB_image_gluten_free?.image = tags_presents.is_gluten_free ?   UIImage.Asset.Img_gluten_free_on.image  :  UIImage.Asset.Img_gluten_free_off_white.image

            if  _current_restaurant.website == nil ||  _current_restaurant.website == "" {

                //TODO: griser case bouton msite web
            }


            guard

                let imageString = _current_restaurant.image,
                let imageURL = NSURL(string: imageString)

            else {

                return
            }

            self.varIB_image_presentation.setImageWithURL(imageURL, placeholder: UIImage.Asset.Img_no_images.image, crossFadePlaceholder: false)

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

        if let phone: String = self.current_restaurant?.phone {


            UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://" + phone)!)
        }
    }


    @IBAction func touch_bt_maps(sender: AnyObject) {

        if let latitude = self.current_restaurant?.lat?.doubleValue, longitude = self.current_restaurant?.lon?.doubleValue {

        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.current_restaurant?.name
        mapItem.openInMapsWithLaunchOptions(options)

        }
    }

    @IBAction func touch_bt_site_web(sender: AnyObject) {


        if let url_str = self.current_restaurant?.website {

            var url_str_avec_prefix = url_str

            if !(url_str_avec_prefix.hasPrefix("http://")) {

                url_str_avec_prefix = "http://\(url_str_avec_prefix)"


            }

            if let url = NSURL(string: url_str_avec_prefix) {

                UIApplication.sharedApplication().openURL( url )
            }
        }



    }


    @IBAction func touch_bt_more_informations(sender: AnyObject) {


        guard

            let url_str = self.current_restaurant?.absolute_url,
            let url = NSURL(string: url_str)

            else {
                return
        }


        UIApplication.sharedApplication().openURL( url )

    }


    @IBAction func touch_bt_share(sender: AnyObject) {

        if let textToShare = self.current_restaurant?.absolute_url {

            let objectsToShare = [textToShare]

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.presentViewController(activityVC, animated: true, completion: nil)

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
