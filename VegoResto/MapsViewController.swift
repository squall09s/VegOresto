//
//  MapsViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MapKit
import SVPulsingAnnotationView

class MapsViewController: UIViewController, MKMapViewDelegate {

    let clusteringManager = FBClusteringManager()

    @IBOutlet weak var varIB_mapView: MKMapView!

    @IBOutlet weak var varIB_bt_filtre_categorie_1: UIButton!
    @IBOutlet weak var varIB_bt_filtre_categorie_2: UIButton!
    @IBOutlet weak var varIB_bt_filtre_categorie_3: UIButton!

    var filtre_categorie: CategorieRestaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.varIB_mapView.showsUserLocation = true

        self.updateData()

        NotificationCenter.default.addObserver(self, selector: #selector(MapsViewController.updateDataAfterDelay), name: NSNotification.Name(rawValue: "CHARGEMENT_TERMINE"), object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        OperationQueue().addOperation({
            let mapBoundsWidth = Double(self.varIB_mapView.bounds.size.width)
            let mapRectWidth: Double = self.varIB_mapView.visibleMapRect.size.width
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: self.varIB_mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:self.varIB_mapView)
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is  FBAnnotationCluster {

            let clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: "Cluster", options: nil)
            clusterView.backgroundColor = UIColor.red

            return clusterView

        } else if annotation is RestaurantAnnotation {

            let reuseId = "myIdentifier"

            var pinView: MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

            if pinView == nil {

                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)

                pinView?.canShowCallout = true

            }

            if let restaurantAnnotation = annotation as? RestaurantAnnotation {

                let myView = UIView()
                myView.backgroundColor = UIColor.clear

                let widthConstraint = NSLayoutConstraint(item: myView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
                myView.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: myView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)

                myView.addConstraint(heightConstraint)

                myView.frame.size = CGSize(width: 220, height: 80)

                self.configurerViewAnnotation( view_support: myView, currentAnnotation: restaurantAnnotation )

                pinView?.detailCalloutAccessoryView = myView

                if let categorie = restaurantAnnotation.restaurant?.categorie() {

                    switch categorie {

                    case CategorieRestaurant.Vegan :
                        pinView?.image = Asset.imgAnotation0.image //  UIImage(asset: .Img_anotation_0)

                    case CategorieRestaurant.Végétarien :
                        pinView?.image = Asset.imgAnotation1.image //UIImage(asset: .Img_anotation_1)

                    case CategorieRestaurant.Traditionnel :
                        pinView?.image = Asset.imgAnotation2.image //UIImage(asset: .Img_anotation_2)

                    }
                }
            }

            pinView?.frame.size = CGSize(width: 144.0/4.0, height: 208.0/4.0)
            pinView?.centerOffset = CGPoint(x : 0, y : -(pinView!.frame.size.height*0.5) )

            return pinView

        } else {

            let reuseId = "currentLocation"

            var pulsingView: SVPulsingAnnotationView? =  mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? SVPulsingAnnotationView

            if pulsingView == nil {

                pulsingView = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pulsingView!.annotationColor = UIColor(red: 0.678431, green: 0.0, blue: 0.0, alpha: 1.0)
                pulsingView!.canShowCallout = true

            }

            return pulsingView
        }
    }

    func configurerViewAnnotation(view_support: UIView, currentAnnotation: RestaurantAnnotation) {

        let largeur_barre_separation: CGFloat = 1.0
        let img_width: CGFloat = 20.0
        let espacement_y: CGFloat = 5.0
        let espacement_x: CGFloat = 15.0

        let hauteur_label_adresse: CGFloat = 23.0

        let view_width = view_support.frame.size.width

        var position_y: CGFloat = 0

        let layer_barre_separation: CALayer = CALayer()
        layer_barre_separation.frame = CGRect( x : view_width * 0.1, y : position_y, width : view_width * 0.8, height : largeur_barre_separation )
        layer_barre_separation.backgroundColor = UIColor.gray
            .cgColor

        view_support.layer.addSublayer(layer_barre_separation)

        position_y += largeur_barre_separation + espacement_y

        let label_adresse: UILabel = UILabel(frame: CGRect( x : 0, y : position_y, width : view_width, height : hauteur_label_adresse ) )
        label_adresse.font = UIFont(name: "URWGothicL-Book", size: 11)!
        label_adresse.numberOfLines = 2
        label_adresse.text = currentAnnotation.restaurant?.address
        view_support.addSubview(label_adresse)

        position_y += hauteur_label_adresse  + espacement_y

        let image_label1: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label1.image = Asset.imgIcPhoneBlack.image // UIImage(asset: .Img_ic_phone_black)
        view_support.addSubview(image_label1)

        let label1: UILabel = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label1.font = UIFont(name: "URWGothicL-Book", size: 12)!
        view_support.addSubview(label1)

        label1.text = currentAnnotation.restaurant?.phone

        position_y += img_width  + espacement_y

        let image_label2: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label2.image = Asset.imgIcMoreBlack.image //UIImage(asset: .Img_ic_more_black)
        view_support.addSubview(image_label2)

        let bt_info = BTTransitionVersDetailsRestaurant(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        bt_info.titleLabel?.font = UIFont(name: "URWGothicL-Book", size: 12)!
        bt_info.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        bt_info.setTitle("Plus d'informations", for: UIControlState.normal)
        bt_info.setTitleColor(UIColor.black, for: UIControlState.normal)
        bt_info.restaurant = currentAnnotation.restaurant
        bt_info.addTarget(self, action: #selector(MapsViewController.touch_bt_more_info(sender:)), for: UIControlEvents.touchUpInside)
        view_support.addSubview(bt_info)

    }

    func touch_bt_more_info(sender: BTTransitionVersDetailsRestaurant) {

        self.performSegue(withIdentifier: StoryboardSegue.Main.segueToDetail.rawValue, sender : sender.restaurant )
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch StoryboardSegue.Main(rawValue: segue.identifier! )! {

        case .segueToDetail:
            // Prepare for your custom segue transition

            if let detailRestaurantVC: DetailRestaurantViewController = segue.destination as? DetailRestaurantViewController {

                if let restaurantCible = sender as? Restaurant {

                    detailRestaurantVC.current_restaurant = restaurantCible
                }

            }
        default :
            break

        }

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let annotation = view.annotation {

            if annotation is FBAnnotationCluster {

            } else if annotation is RestaurantAnnotation {

                //if let restaurantAnnotation = annotation as? RestaurantAnnotation {

                //}

            }

        }

    }

    // permet de conserver l'annotation de la position de l'user toujours au dessus des autres (Z-Index).

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {

        for view: MKAnnotationView in views {
            if let annotation = view.annotation {

                if annotation is MKUserLocation {
                    view.superview?.bringSubview(toFront: view)
                } else {
                    view.superview?.sendSubview(toBack: view)
                }
            }
        }

    }

    func update_region_for_user_location() {

        if let location = UserData.sharedInstance.location {

            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            self.varIB_mapView.setRegion(region, animated: true)

        }
    }

    @IBAction func touch_bt_categorie(sender: UIButton) {

        if sender == self.varIB_bt_filtre_categorie_1 {

            if self.filtre_categorie != CategorieRestaurant.Végétarien {
                self.filtre_categorie = CategorieRestaurant.Végétarien
            } else {
                self.filtre_categorie = nil
            }

        } else if sender == self.varIB_bt_filtre_categorie_2 {

            if self.filtre_categorie != CategorieRestaurant.Vegan {
                self.filtre_categorie = CategorieRestaurant.Vegan
            } else {
                self.filtre_categorie = nil
            }

        } else if sender == self.varIB_bt_filtre_categorie_3 {

            if self.filtre_categorie != CategorieRestaurant.Traditionnel {
                self.filtre_categorie = CategorieRestaurant.Traditionnel
            } else {
                self.filtre_categorie = nil
            }

        }

        if self.filtre_categorie == CategorieRestaurant.Végétarien {

            self.varIB_bt_filtre_categorie_1.backgroundColor = COLOR_VIOLET
            self.varIB_bt_filtre_categorie_2.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)
            self.varIB_bt_filtre_categorie_3.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)

        } else if self.filtre_categorie == CategorieRestaurant.Vegan {

            self.varIB_bt_filtre_categorie_1.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)
            self.varIB_bt_filtre_categorie_2.backgroundColor = COLOR_VERT
            self.varIB_bt_filtre_categorie_3.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)

        } else if self.filtre_categorie == CategorieRestaurant.Traditionnel {

            self.varIB_bt_filtre_categorie_1.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)
            self.varIB_bt_filtre_categorie_2.backgroundColor = COLOR_GRIS_FONCÉ.withAlphaComponent(0.6)
            self.varIB_bt_filtre_categorie_3.backgroundColor = COLOR_BLEU

        } else {

            self.varIB_bt_filtre_categorie_1.backgroundColor = COLOR_VIOLET
            self.varIB_bt_filtre_categorie_2.backgroundColor = COLOR_VERT
            self.varIB_bt_filtre_categorie_3.backgroundColor = COLOR_BLEU
        }

        self.updateData()
    }

    func updateData() {

        var array: [FBAnnotation] = [FBAnnotation]()

        let restaurants = UserData.sharedInstance.getRestaurants().flatMap { (currentResto) -> Restaurant? in

            if currentResto.categorie() == self.filtre_categorie || self.filtre_categorie == nil {

                return currentResto

            } else {

                return nil

            }

        }

        for restaurant in restaurants {

            if let lat = restaurant.lat, let lon = restaurant.lon {

                let current_pin = RestaurantAnnotation(_restaurant : restaurant)

                current_pin.coordinate = CLLocationCoordinate2D(latitude:  Double(lat), longitude: Double(lon) )
                array.append(current_pin)
            }
        }

        clusteringManager.setAnnotations(annotations: array)

        let mapBoundsWidth = Double(self.varIB_mapView.bounds.size.width)
        let mapRectWidth: Double = self.varIB_mapView.visibleMapRect.size.width
        let scale: Double = mapBoundsWidth / mapRectWidth
        let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: self.varIB_mapView.visibleMapRect, withZoomScale:scale)
        self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:self.varIB_mapView)

    }

    func updateDataAfterDelay() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            self.updateData()
        }

    }

}

class BTTransitionVersDetailsRestaurant: UIButton {

    var restaurant: Restaurant?

}
