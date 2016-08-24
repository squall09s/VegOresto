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

    @IBOutlet weak var varIB_label_name: UILabel?
    @IBOutlet weak var varIB_label_resume: UILabel?


    @IBOutlet weak var varIB_label_adresse: UILabel?
    @IBOutlet weak var varIB_label_phone: UILabel?
    @IBOutlet weak var varIB_label_ambiance: UILabel?
    @IBOutlet weak var varIB_label_type_etablissement: UILabel?
    @IBOutlet weak var varIB_label_facebook: UILabel?
    @IBOutlet weak var varIB_label_website: UILabel?
    @IBOutlet weak var varIB_label_montant_moyen: UILabel?

    @IBOutlet weak var varIB_label_terrasse: UILabel?
    @IBOutlet weak var varIB_label_animaux: UILabel?


    @IBOutlet weak var varIB_label_h_lundi: UILabel?
    @IBOutlet weak var varIB_label_h_mardi: UILabel?
    @IBOutlet weak var varIB_label_h_mercredi: UILabel?
    @IBOutlet weak var varIB_label_h_jeudi: UILabel?
    @IBOutlet weak var varIB_label_h_vendredi: UILabel?
    @IBOutlet weak var varIB_label_h_samedi: UILabel?
    @IBOutlet weak var varIB_label_h_dimanche: UILabel?

    @IBOutlet weak var varIB_label_h_midi: UILabel?
    @IBOutlet weak var varIB_label_h_soir: UILabel?
    @IBOutlet weak var varIB_label_h_fermeture: UILabel?


    @IBOutlet weak var varIB_button_favoris: UIButton?


    @IBOutlet weak var varIB_image_vegan: UIImageView?
    @IBOutlet weak var varIB_image_gluten_free: UIImageView?



    @IBOutlet weak var varIB_scroll: UIScrollView?
    @IBOutlet weak var varIB_image_presentation: UIImageView?

    var current_restaurant: Restaurant? = nil

    override func viewDidLoad() {
        super.viewDidLoad()


        if let _current_restaurant =  self.current_restaurant {


            self.varIB_label_name?.text = _current_restaurant.name
            self.varIB_label_resume?.text = _current_restaurant.resume
            self.varIB_label_adresse?.text = _current_restaurant.address
            self.varIB_label_phone?.text = _current_restaurant.phone
            self.varIB_label_ambiance?.text = _current_restaurant.ambiance
            self.varIB_label_type_etablissement?.text = _current_restaurant.type_etablissement
            self.varIB_label_facebook?.text = _current_restaurant.facebook
            self.varIB_label_website?.text = _current_restaurant.website
            self.varIB_label_montant_moyen?.text = _current_restaurant.montant_moyen

            self.varIB_label_h_lundi?.text = _current_restaurant.h_lundi
            self.varIB_label_h_mardi?.text = _current_restaurant.h_mardi
            self.varIB_label_h_mercredi?.text = _current_restaurant.h_mercredi
            self.varIB_label_h_jeudi?.text = _current_restaurant.h_jeudi
            self.varIB_label_h_vendredi?.text = _current_restaurant.h_vendredi
            self.varIB_label_h_samedi?.text = _current_restaurant.h_samedi
            self.varIB_label_h_dimanche?.text = _current_restaurant.h_dimanche

            self.varIB_label_h_midi?.text = _current_restaurant.h_midi
            self.varIB_label_h_soir?.text = _current_restaurant.h_soir
            self.varIB_label_h_fermeture?.text = _current_restaurant.fermeture

            if let boolValue = _current_restaurant.animaux_bienvenus?.boolValue {
                if boolValue {
                self.varIB_label_animaux?.text = "Oui !"
                }
            }

            if let boolValue = _current_restaurant.terrasse?.boolValue {
                if boolValue {
                    self.varIB_label_terrasse?.text = "Oui !"
                }
            }

            self.refreshBt_favoris()


            let tags_presents = _current_restaurant.tags_are_present()


            varIB_image_vegan?.image = tags_presents.is_vegan ? UIImage(asset: .Img_vegan_on) : UIImage(asset: .Img_vegan_off_white)
            varIB_image_gluten_free?.image = tags_presents.is_gluten_free ?   UIImage(asset: .Img_gluten_free_on)  :  UIImage(asset: .Img_gluten_free_off_white)

            if  _current_restaurant.website == nil ||  _current_restaurant.website == "" {

                //TODO: griser case bouton msite web
            }


            guard

                let imageString = _current_restaurant.image,
                let imageURL = NSURL(string: imageString)

                else {

                    return
            }

            Debug.log("image url = \(imageURL)")

            self.varIB_image_presentation?.setImageWithURL(imageURL, placeholder: UIImage(asset: .Img_no_images), crossFadePlaceholder: false)


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

       self.navigationController?.popViewControllerAnimated( true)
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


    /*

    @IBAction func touch_bt_more_informations(sender: AnyObject) {


        guard

            let url_str = self.current_restaurant?.absolute_url,
            let url = NSURL(string: url_str)

            else {
                return
        }


        UIApplication.sharedApplication().openURL( url )

    }
*/

    @IBAction func touch_bt_share(sender: AnyObject) {

        if let textToShare = self.current_restaurant?.absolute_url {

            let objectsToShare = [textToShare]

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.presentViewController(activityVC, animated: true, completion: nil)

        }
    }



    @IBAction func touch_bt_favoris(sender: AnyObject) {

        if let _current_restaurant = self.current_restaurant {

            _current_restaurant.favoris = !(_current_restaurant.favoris.boolValue)

        }

        self.refreshBt_favoris()


    }


    func refreshBt_favoris() {

        if let _current_restaurant = self.current_restaurant {

            if _current_restaurant.favoris.boolValue {

                self.varIB_button_favoris?.setImage(  UIImage(asset: .Img_favoris_orange_on ), forState: UIControlState())

            } else {

                self.varIB_button_favoris?.setImage(  UIImage(asset: .Img_favoris_orange_off ), forState: UIControlState())
            }

        }

    }


    @IBAction func touch_bt_mail(sender: AnyObject) {



    }

    @IBAction func touch_bt_weburl(sender: AnyObject) {


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

    @IBAction func touch_bt_facebook(sender: AnyObject) {



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
