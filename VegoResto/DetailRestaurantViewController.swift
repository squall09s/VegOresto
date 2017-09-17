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
    @IBOutlet weak var varIB_label_influences: UILabel?
    @IBOutlet weak var varIB_label_moyens_de_paiement: UILabel?

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
    @IBOutlet weak var varIB_label_categories: UILabel?

    @IBOutlet weak var varIB_scroll: UIScrollView?
    @IBOutlet weak var varIB_image_presentation: UIImageView?

    @IBOutlet weak var varIB_image_rating_1: UIImageView?
    @IBOutlet weak var varIB_image_rating_2: UIImageView?
    @IBOutlet weak var varIB_image_rating_3: UIImageView?
    @IBOutlet weak var varIB_image_rating_4: UIImageView?
    @IBOutlet weak var varIB_image_rating_5: UIImageView?

    @IBOutlet weak var varIB_button_maps: UIButton?
    @IBOutlet weak var varIB_button_phone: UIButton?
    @IBOutlet weak var varIB_button_mail: UIButton?
    @IBOutlet weak var varIB_button_website: UIButton?
    @IBOutlet weak var varIB_button_facebook: UIButton?

    @IBOutlet weak var varIB_button_comment: UIButton?
    @IBOutlet weak var varIB_label_number_comment: UILabel?
    @IBOutlet weak var varIB_activity_indicator: UIActivityIndicatorView?

    var current_restaurant: Restaurant?

    override func viewDidLoad() {

        super.viewDidLoad()

        if let _current_restaurant =  self.current_restaurant {

            self.varIB_label_name?.text = _current_restaurant.name
            self.varIB_label_resume?.text = _current_restaurant.resume
            self.varIB_label_ambiance?.text = _current_restaurant.ambiance
            self.varIB_label_type_etablissement?.text = _current_restaurant.type_etablissement
            self.varIB_label_montant_moyen?.text = _current_restaurant.montant_moyen
            self.varIB_label_influences?.text = _current_restaurant.influence_gastronomique

            self.varIB_label_moyens_de_paiement?.text = _current_restaurant.moyens_de_paiement

            if let horaire = UserData.sharedInstance.getHoraires(for: _current_restaurant) {
                self.varIB_label_h_lundi?.text = horaire.dataL
                self.varIB_label_h_mardi?.text = horaire.dataMa
                self.varIB_label_h_mercredi?.text = horaire.dataMe
                self.varIB_label_h_jeudi?.text = horaire.dataJ
                self.varIB_label_h_vendredi?.text = horaire.dataV
                self.varIB_label_h_samedi?.text = horaire.dataS
                self.varIB_label_h_dimanche?.text = horaire.dataD
            }

            self.varIB_label_animaux?.text = _current_restaurant.animaux_bienvenus?.boolValue == true ? "Oui !" : "Non"
            self.varIB_label_terrasse?.text = _current_restaurant.terrasse?.boolValue == true ? "Oui !" : "Non"

            var categoriesCulinaireString = ""
            var i = 0

            for cat in self.current_restaurant?.getCategoriesCulinaireAsArray() ?? [] {

                if let catName = cat.name {

                    if i > 0 {
                        categoriesCulinaireString += ", "
                    }

                    categoriesCulinaireString += catName

                    i += 1

                }
            }

            self.varIB_label_categories?.text = categoriesCulinaireString

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

            self.varIB_image_vegan?.isHidden = _current_restaurant.categorie() != .Vegan

        }

        switch self.getDayOfWeek() {
        case 2:
            self.varIB_label_h_lundi?.textColor = COLOR_ORANGE
        case 3:
            self.varIB_label_h_mardi?.textColor = COLOR_ORANGE
        case 4:
            self.varIB_label_h_mercredi?.textColor = COLOR_ORANGE
        case 5:
            self.varIB_label_h_jeudi?.textColor = COLOR_ORANGE
        case 6:
            self.varIB_label_h_vendredi?.textColor = COLOR_ORANGE
        case 7:
            self.varIB_label_h_samedi?.textColor = COLOR_ORANGE
        case 1:
            self.varIB_label_h_dimanche?.textColor = COLOR_ORANGE
        default:
            break
        }

        self.varIB_activity_indicator?.isHidden = false
        self.varIB_button_comment?.isHidden = true
        self.varIB_activity_indicator?.startAnimating()

        self.varIB_activity_indicator?.isHidden = true
        self.varIB_button_comment?.isHidden = false

        self.updateRatingImage()

        WebRequestManager.shared.listComment(restaurant : self.current_restaurant, success: { (_) in

            self.updateLabelComment()

            self.varIB_activity_indicator?.stopAnimating()

            UIView.animate(withDuration: 0.5, animations: {

                self.varIB_activity_indicator?.isHidden = true
                self.varIB_button_comment?.isHidden = false

            })

        }) { (_) in

            self.updateLabelComment()

            self.varIB_activity_indicator?.stopAnimating()

            UIView.animate(withDuration: 0.5, animations: {

                self.varIB_activity_indicator?.isHidden = true
                self.varIB_button_comment?.isHidden = false

            })

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

    func getDayOfWeek() -> Int {

        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
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
                        //print("Notification dismissed")
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

    func updateLabelComment() {

        if let nbComment = self.current_restaurant?.getCommentsAsArray()?.count {

            if nbComment > 0 {
                self.varIB_label_number_comment?.text = "Tous les avis [\(nbComment)]"
            } else {
                self.varIB_label_number_comment?.text = "Aucun avis pour le moment"
            }

        } else {

            self.varIB_label_number_comment?.text = "Aucun avis pour le moment"

        }
    }

    func updateRatingImage() {

        if let rating = self.current_restaurant?.rating?.doubleValue {

            if rating == 0.5 {
                self.varIB_image_rating_1?.image = Asset.imgFavorisStarHalf.image
            } else if rating > 0.5 {
                self.varIB_image_rating_1?.image = Asset.imgFavorisStarOn.image
            } else {
                self.varIB_image_rating_1?.image = Asset.imgFavorisStarOff.image
            }

            if rating == 1.5 {
                self.varIB_image_rating_2?.image = Asset.imgFavorisStarHalf.image
            } else if rating > 1.5 {
                self.varIB_image_rating_2?.image = Asset.imgFavorisStarOn.image
            } else {
                self.varIB_image_rating_2?.image = Asset.imgFavorisStarOff.image
            }

            if rating == 2.5 {
                self.varIB_image_rating_3?.image = Asset.imgFavorisStarHalf.image
            } else if rating > 2.5 {
                self.varIB_image_rating_3?.image = Asset.imgFavorisStarOn.image
            } else {
                self.varIB_image_rating_3?.image = Asset.imgFavorisStarOff.image
            }

            if rating == 3.5 {
                self.varIB_image_rating_4?.image = Asset.imgFavorisStarHalf.image
            } else if rating > 3.5 {
                self.varIB_image_rating_4?.image = Asset.imgFavorisStarOn.image
            } else {
                self.varIB_image_rating_4?.image = Asset.imgFavorisStarOff.image
            }

            if rating == 4.5 {
                self.varIB_image_rating_5?.image = Asset.imgFavorisStarHalf.image
            } else if rating > 4.5 {
                self.varIB_image_rating_5?.image = Asset.imgFavorisStarOn.image
            } else {
                self.varIB_image_rating_5?.image = Asset.imgFavorisStarOff.image
            }

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segue_to_comments" {

            if let destination: TableCommentsViewController = segue.destination as? TableCommentsViewController {

                destination.comments = self.current_restaurant?.getCommentsAsArray() ?? []

            }

        }

    }

}
