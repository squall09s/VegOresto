//
//  DetailRestaurantViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 01/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MapleBacon
import LNRSimpleNotifications
import FaveButton

class DetailRestaurantViewController: UIViewController, UIScrollViewDelegate {

    //@IBOutlet weak var varIB_label_name: UILabel?

    @IBOutlet weak var varIB_pageControl: UIPageControl?

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

    @IBOutlet weak var varIB_button_favoris: FaveButton?

    @IBOutlet weak var varIB_label_categories: UILabel?
    @IBOutlet weak var varIB_scrollViewImages: UIScrollView?

    @IBOutlet weak var varIB_constraintWidthLine_maps: NSLayoutConstraint?
    @IBOutlet weak var varIB_constraintWidthLine_phone: NSLayoutConstraint?
    @IBOutlet weak var varIB_constraintWidthLine_mail: NSLayoutConstraint?
    @IBOutlet weak var varIB_constraintWidthLine_website: NSLayoutConstraint?
    @IBOutlet weak var varIB_constraintWidthLine_facebook: NSLayoutConstraint?

    @IBOutlet weak var varIB_scroll: UIScrollView?

    @IBOutlet weak var varIB_image_rating_1: UIImageView?
    @IBOutlet weak var varIB_image_rating_2: UIImageView?
    @IBOutlet weak var varIB_image_rating_3: UIImageView?
    @IBOutlet weak var varIB_image_rating_4: UIImageView?
    @IBOutlet weak var varIB_image_rating_5: UIImageView?

    @IBOutlet weak var varIB_button_comment: UIButton?
    @IBOutlet weak var varIB_label_number_comment: UILabel?
    @IBOutlet weak var varIB_activity_indicator: UIActivityIndicatorView?

    var current_restaurant: Restaurant?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName: UIColor.white]

        self.varIB_button_favoris?.normalColor = UIColor(hexString: "F1EFF2")
        self.varIB_button_favoris?.selectedColor = COLOR_ORANGE

        updateDayOfWeekLabel()
        updateRestaurantInterface()
        updateRatingImage()
        updateLabelComment()

        // load comments
        loadComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Update

    static private func getDayOfWeek() -> Int {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    private func updateDayOfWeekLabel() {
        switch DetailRestaurantViewController.getDayOfWeek() {
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
    }
    
    private func updateRestaurantInterface() {
        guard let restaurant =  self.current_restaurant else {
            return
        }
        
        self.title = restaurant.name
        
        //self.varIB_label_name?.text = restaurant.name
        self.varIB_label_resume?.text = restaurant.resume
        self.varIB_label_ambiance?.text = restaurant.ambiance
        self.varIB_label_type_etablissement?.text = restaurant.type_etablissement
        self.varIB_label_montant_moyen?.text = restaurant.montant_moyen
        self.varIB_label_influences?.text = restaurant.influence_gastronomique
        
        self.varIB_label_moyens_de_paiement?.text = restaurant.moyens_de_paiement
        
        if let horaire = UserData.shared.viewContext.getHoraire(restaurant: restaurant) {
            self.varIB_label_h_lundi?.text = !(horaire.dataL ?? "").isEmpty ? horaire.dataL : "Fermé"
            self.varIB_label_h_mardi?.text = !(horaire.dataMa ?? "").isEmpty ? horaire.dataMa : "Fermé"
            self.varIB_label_h_mercredi?.text = !(horaire.dataMe ?? "").isEmpty ? horaire.dataMe : "Fermé"
            self.varIB_label_h_jeudi?.text = !(horaire.dataJ ?? "").isEmpty ? horaire.dataJ : "Fermé"
            self.varIB_label_h_vendredi?.text = !(horaire.dataV ?? "").isEmpty ? horaire.dataV : "Fermé"
            self.varIB_label_h_samedi?.text = !(horaire.dataS ?? "").isEmpty ? horaire.dataS : "Fermé"
            self.varIB_label_h_dimanche?.text = !(horaire.dataD ?? "").isEmpty ? horaire.dataD : "Fermé"
        } else {
            self.varIB_label_h_lundi?.text = "Inconnu"
            self.varIB_label_h_mardi?.text = "Inconnu"
            self.varIB_label_h_mercredi?.text = "Inconnu"
            self.varIB_label_h_jeudi?.text = "Inconnu"
            self.varIB_label_h_vendredi?.text = "Inconnu"
            self.varIB_label_h_samedi?.text = "Inconnu"
            self.varIB_label_h_dimanche?.text = "Inconnu"
        }
        
        self.varIB_label_animaux?.text = restaurant.animaux_bienvenus?.boolValue == true ? "Oui !" : "Non"
        self.varIB_label_terrasse?.text = restaurant.terrasse?.boolValue == true ? "Oui !" : "Non"
        
        let categoriesCulinaireString = restaurant.categoriesCulinairesArray.flatMap { cat -> String? in
            return cat.name
        }.joined(separator: ", ")
        
        self.varIB_label_categories?.text = categoriesCulinaireString
        
        self.refreshBt_favoris()
        
        if  restaurant.website != nil &&  restaurant.website != "" {
            self.varIB_label_website?.text = restaurant.website
        } else {
            self.varIB_constraintWidthLine_website?.constant = 0
        }
        
        if  restaurant.phone != nil &&  restaurant.phone != "" {
            self.varIB_label_phone?.text = restaurant.phone
        } else {
            self.varIB_constraintWidthLine_phone?.constant = 0
        }
        
        if let facebookPage = restaurant.facebookPage {
            self.varIB_label_facebook?.text = facebookPage
        } else {
            self.varIB_constraintWidthLine_facebook?.constant = 0
        }
        
        if  restaurant.mail != nil &&  restaurant.mail != "" {
            self.varIB_label_mail?.text = restaurant.mail
        } else {
            self.varIB_constraintWidthLine_mail?.constant = 0
        }
        
        if  restaurant.address != nil &&  restaurant.address != "" {
            self.varIB_label_adresse?.text = restaurant.address
        } else {
            self.varIB_constraintWidthLine_maps?.constant = 0
        }
        
        let imagesURLs = restaurant.imagesURLs
        
        self.varIB_scrollViewImages?.contentSize = CGSize(width: CGFloat(imagesURLs.count) * Device.WIDTH, height: Device.WIDTH * (300.0/720.0))
        
        self.varIB_pageControl?.isHidden = imagesURLs.count <= 1
        self.varIB_pageControl?.numberOfPages = imagesURLs.count
        
        var j: Int = 0
        for imagesURL in imagesURLs {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(j) * Device.WIDTH, y: 0, width: Device.WIDTH, height: Device.WIDTH * (300.0/720.0)))
            
            imageView.image = UIImage(named: "image_resto_placeolder")
            imageView.contentMode = .scaleAspectFit
            
            self.varIB_scrollViewImages?.addSubview(imageView)
            
            imageView.setImage(withUrl: imagesURL, placeholder: UIImage(named: "image_resto_placeolder"), crossFadePlaceholder: false, cacheScaled: false, completion: { (_, _) in
                
            })
            
            j += 1
        }
    }
    
    private func updateLabelComment() {
        if let nbComment = self.current_restaurant?.commentsRootArray.count, nbComment > 0 {
            self.varIB_label_number_comment?.text = "Tous les avis [\(nbComment)]"
        } else {
            self.varIB_label_number_comment?.text = "Aucun avis pour le moment"
        }
    }

    private func updateRatingImage() {
        let rating = self.current_restaurant?.rating?.doubleValue ?? 1
        
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

    // MARK: Networking
    
    private func loadComments() {
        guard let restaurant = self.current_restaurant else {
            return
        }
        
        self.varIB_activity_indicator?.startAnimating()
        self.varIB_button_comment?.isHidden = true

        WebRequestManager.shared.loadComments(restaurant: restaurant).always {
            self.updateLabelComment()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.varIB_activity_indicator?.stopAnimating()
                self.varIB_button_comment?.isHidden = false
            })
        }
    }
    
    // MARK: IBActions

    @IBAction func touch_bt_back(sender: AnyObject) {

        _ = self.navigationController?.popViewController( animated: true)
    }

    @IBAction func touch_bt_phone(sender: AnyObject) {
        guard let phoneNumber = self.current_restaurant?.phone else {
            return
        }
        Deeplinking.openPhone(phoneNumber: phoneNumber)
    }

    @IBAction func touch_bt_maps(sender: AnyObject) {
        guard self.current_restaurant?.location != nil else {
            return
        }

        let alert = UIAlertController(title: "C'est parti !",
                                      message: "Ouvrir l'itinéraire vers ce restaurant ?",
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Plan", style: .default, handler: { (_) -> Void in
            self.launchAppleMaps()
        })
        alert.addAction(action1)

        if Deeplinking.canOpenGoogleMaps() {
            let action2 = UIAlertAction(title: "Google Maps", style: .default, handler: { (_) -> Void in
                self.launchGoogleMaps()
            })
            alert.addAction(action2)
        }

        // Cancel button
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: { (_) -> Void in })

        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    private func launchGoogleMaps() {
        guard let location = self.current_restaurant?.location else {
            return
        }
        Deeplinking.openGoogleMaps(location: location.coordinate)
    }

    private func launchAppleMaps() {
        guard let location = self.current_restaurant?.location else {
            return
        }

        let regionDistance: CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(location.coordinate, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.current_restaurant?.name
        mapItem.openInMaps(launchOptions: options)
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

             _current_restaurant.favoris = !(_current_restaurant.favoris.boolValue) as NSNumber

            /*
            let notificationManager = LNRNotificationManager()

            if !(notificationManager.isNotificationActive) {

             
                notificationManager.notificationsPosition = LNRNotificationPosition.top
                notificationManager.notificationsBackgroundColor = COLOR_ORANGE
                notificationManager.notificationsTitleTextColor = UIColor.white
                notificationManager.notificationsBodyTextColor = UIColor.white
                notificationManager.notificationsSeperatorColor = UIColor.white

                notificationManager.notificationsTitleFont = UIFont(name: "URWGothicL-Book", size: 15)!
                notificationManager.notificationsBodyFont = UIFont(name: "URWGothicL-Book", size: 11)!
                //notificationManager.notificationsIcon = UIImage(asset: .Img_favoris_wh)

                let message = _current_restaurant.favoris.boolValue ? "Vous avez bien ajouté ce restaurant à vos favoris" : "Vous avez bien retiré ce restaurant de vos favoris"

                notificationManager.showNotification(notification: LNRNotification(title: "Favoris", body: message, duration: 1.5, onTap: { () in

                }, onTimeout: { () in

                }))

            }*/
        }

        self.refreshBt_favoris()
    }

    func refreshBt_favoris() {

        if let _current_restaurant = self.current_restaurant {

            if self.varIB_button_favoris!.isSelected != _current_restaurant.favoris.boolValue {
                self.varIB_button_favoris?.isSelected = _current_restaurant.favoris.boolValue
            }
        }

    }

    @IBAction func touch_bt_mail(sender: AnyObject) {
        guard let emailAddress = self.current_restaurant?.mail else {
            return
        }
        Deeplinking.openSendEmail(to: emailAddress, subject: "Prise de contact")
    }

    @IBAction func touch_bt_weburl(sender: AnyObject) {
        guard let websiteUrl = self.current_restaurant?.website else {
            return
        }
        Deeplinking.openWebsite(url: websiteUrl)
    }

    @IBAction func touch_bt_facebook(sender: AnyObject) {
        guard let facebookURL = self.current_restaurant?.facebookURL else {
            return
        }
        Deeplinking.openURL(facebookURL)
    }

    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_to_comments" {
            if let destination: TableCommentsViewController = segue.destination as? TableCommentsViewController {
                destination.currentRestaurant = self.current_restaurant
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == varIB_scrollViewImages {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.varIB_pageControl?.currentPage = Int(pageNumber)
        }
    }
}
