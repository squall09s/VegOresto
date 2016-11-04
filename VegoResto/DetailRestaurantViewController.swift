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
import LNRSimpleNotifications

class DetailRestaurantViewController: UIViewController {

    @IBOutlet weak var varIB_label_name: UILabel?
    @IBOutlet weak var varIB_label_resume: UILabel?


    @IBOutlet weak var varIB_label_adresse: UILabel?
    @IBOutlet weak var varIB_label_phone: UILabel?
    @IBOutlet weak var varIB_label_ambiance: UILabel?
    @IBOutlet weak var varIB_label_type_etablissement: UILabel?
    @IBOutlet weak var varIB_label_facebook: UILabel?
    @IBOutlet weak var varIB_label_mail: UILabel?
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


    @IBOutlet weak var varIB_button_favoris: UIButton?


    @IBOutlet weak var varIB_image_vegan: UIImageView?
    @IBOutlet weak var varIB_image_gluten_free: UIImageView?



    @IBOutlet weak var varIB_scroll: UIScrollView?
    @IBOutlet weak var varIB_image_presentation: UIImageView?



    @IBOutlet weak var varIB_button_maps: UIButton?
    @IBOutlet weak var varIB_button_phone: UIButton?
    @IBOutlet weak var varIB_button_mail: UIButton?
    @IBOutlet weak var varIB_button_website: UIButton?
    @IBOutlet weak var varIB_button_facebook: UIButton?


    var current_restaurant: Restaurant? = nil

    override func viewDidLoad() {

        super.viewDidLoad()

        if let _current_restaurant =  self.current_restaurant {


            self.varIB_label_name?.text = _current_restaurant.name
            self.varIB_label_resume?.text = _current_restaurant.resume
            self.varIB_label_ambiance?.text = _current_restaurant.ambiance
            self.varIB_label_type_etablissement?.text = _current_restaurant.type_etablissement
            self.varIB_label_montant_moyen?.text = _current_restaurant.montant_moyen

            self.varIB_label_h_lundi?.text = _current_restaurant.h_lundi
            self.varIB_label_h_mardi?.text = _current_restaurant.h_mardi
            self.varIB_label_h_mercredi?.text = _current_restaurant.h_mercredi
            self.varIB_label_h_jeudi?.text = _current_restaurant.h_jeudi
            self.varIB_label_h_vendredi?.text = _current_restaurant.h_vendredi
            self.varIB_label_h_samedi?.text = _current_restaurant.h_samedi
            self.varIB_label_h_dimanche?.text = _current_restaurant.h_dimanche


            self.varIB_label_animaux?.text = _current_restaurant.animaux_bienvenus?.boolValue == true ? "Oui !" : "Non"
            self.varIB_label_terrasse?.text = _current_restaurant.terrasse?.boolValue == true ? "Oui !" : "Non"

            self.refreshBt_favoris()


            if  _current_restaurant.website != nil &&  _current_restaurant.website != "" {
                self.varIB_button_website?.setImage( Asset.imgBtWebOrangeOn.image, for: UIControlState())
                self.varIB_button_website?.isUserInteractionEnabled = true
                self.varIB_label_website?.text = _current_restaurant.website
            }


            if  _current_restaurant.phone != nil &&  _current_restaurant.phone != "" {
                self.varIB_button_phone?.setImage( Asset.imgBtTelOrangeOn.image, for: UIControlState())
                self.varIB_button_phone?.isUserInteractionEnabled = true
                self.varIB_label_phone?.text = _current_restaurant.phone
            }


            if  _current_restaurant.facebook != nil &&  _current_restaurant.facebook != "" {
                self.varIB_button_facebook?.setImage( Asset.imgBtFbOrangeOn.image, for: UIControlState())
                self.varIB_button_facebook?.isUserInteractionEnabled = true
                self.varIB_label_facebook?.text = _current_restaurant.facebook
            }


            if  _current_restaurant.mail != nil &&  _current_restaurant.mail != "" {
                self.varIB_button_mail?.setImage( Asset.imgBtMailOrangeOn.image, for: UIControlState())
                self.varIB_button_mail?.isUserInteractionEnabled = true
                self.varIB_label_mail?.text = _current_restaurant.mail
            }


            if  _current_restaurant.address != nil &&  _current_restaurant.address != "" {
                self.varIB_button_maps?.setImage( Asset.imgBtMapsOrangeOn.image, for: UIControlState())
                self.varIB_button_maps?.isUserInteractionEnabled = true
                self.varIB_label_adresse?.text = _current_restaurant.address
            }

            if let imageString = _current_restaurant.image {
                if let imgURL = URL(string: imageString) {

                    self.varIB_image_presentation?.setImage(withUrl: imgURL, placeholder: Asset.imgNoImages.image, crossFadePlaceholder: false, cacheScaled: false, completion: nil)

                }
            }


        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

    }



    @IBAction func touch_bt_back(sender: AnyObject) {

       _ = self.navigationController?.popViewController( animated: true)
    }


    @IBAction func touch_bt_phone(sender: AnyObject) {

        if let phone: String = self.current_restaurant?.phone {

            var phoneClean = phone.replacingOccurrences(of: " ", with: "")

            phoneClean = phoneClean.replacingOccurrences(of : ".", with: "")

            if let destination_url = URL(string: "telprompt://" + phoneClean) {

                UIApplication.shared.open(destination_url, options: [:], completionHandler: nil)

            }
        }
    }


    @IBAction func touch_bt_maps(sender: AnyObject) {

        if let latitude = self.current_restaurant?.lat?.doubleValue, let longitude = self.current_restaurant?.lon?.doubleValue {

            let regionDistance: CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.current_restaurant?.name
            mapItem.openInMaps(launchOptions: options)

        }
    }


    @IBAction func touch_bt_share(sender: AnyObject) {

        if let textToShare = self.current_restaurant?.absolute_url {

            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }


    @IBAction func touch_bt_favoris(sender: AnyObject) {

        if let _current_restaurant = self.current_restaurant {

            let notificationManager = LNRNotificationManager()

            if !(notificationManager.isNotificationActive) {

            _current_restaurant.favoris = !(_current_restaurant.favoris.boolValue) as NSNumber



            notificationManager.notificationsPosition = LNRNotificationPosition.top
            notificationManager.notificationsBackgroundColor = COLOR_ORANGE
            notificationManager.notificationsTitleTextColor = UIColor.white
            notificationManager.notificationsBodyTextColor = UIColor.white
            notificationManager.notificationsSeperatorColor = UIColor.white

            notificationManager.notificationsTitleFont = UIFont(name: "URWGothicL-Book", size: 15)!
            notificationManager.notificationsBodyFont = UIFont(name: "URWGothicL-Book", size: 11)!
            //notificationManager.notificationsIcon = UIImage(asset: .Img_favoris_wh)

            let message = _current_restaurant.favoris.boolValue ? "Vous avez bien ajouté ce restaurant à vos favoris" : "Vous avez bien retiré ce restaurant de vos favoris"

            notificationManager.showNotification(title: "Favoris", body: message, onTap: { () -> Void in

                _ = notificationManager.dismissActiveNotification(completion: { () -> Void in
                        print("Notification dismissed")
                    })
                })

            }
        }

        self.refreshBt_favoris()
    }


    func refreshBt_favoris() {

        if let _current_restaurant = self.current_restaurant {

            if _current_restaurant.favoris.boolValue {
                self.varIB_button_favoris?.setImage(  Asset.imgFavorisOrangeOn.image, for: UIControlState())
            } else {
                self.varIB_button_favoris?.setImage(  Asset.imgFavorisOrangeOff.image, for: UIControlState())
            }
        }

    }


    @IBAction func touch_bt_mail(sender: AnyObject) {

        if let mail = self.current_restaurant?.mail {

        if let sujet = "Prise de contact".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {

            if let destination_url = URL(string:  "mailto:" + mail + "?subject=" + sujet ) {

                UIApplication.shared.open(destination_url, options: [:], completionHandler: nil)

            }

        }
        }

    }

    @IBAction func touch_bt_weburl(sender: AnyObject) {

        if let url_str = self.current_restaurant?.website {

            var destination_url_str = url_str

            if !(url_str.hasPrefix("http")) {

                destination_url_str = "http://\(url_str)"
            }

            if let destination_url = URL(string:  destination_url_str ) {

                UIApplication.shared.open(destination_url, options: [:], completionHandler: nil)

            }


        }


    }

    @IBAction func touch_bt_facebook(sender: AnyObject) {


        if let url_str = self.current_restaurant?.facebook {

            var destination_url_str = url_str

            if !(url_str.hasPrefix("http")) {

                destination_url_str = "http://\(url_str)"
            }

            if let destination_url = URL(string:  destination_url_str ) {

                UIApplication.shared.open(destination_url, options: [:], completionHandler: nil)

            }


        }
    }


}
