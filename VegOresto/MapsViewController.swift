//
//  MapsViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MapKit
import SVPulsingAnnotationView

class MapsViewController: VGAbstractFilterViewController, MKMapViewDelegate {

    let clusteringManager = FBClusteringManager()

    @IBOutlet weak var varIB_mapView: MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.varIB_mapView?.showsUserLocation = true

        self.updateData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let _varIB_mapView = self.varIB_mapView else {
            return
        }

        // get map bounding box (on the main thread)
        let mapBoundsWidth = Double(_varIB_mapView.bounds.size.width)
        let mapRectWidth: Double = _varIB_mapView.visibleMapRect.size.width

        // perform clustering on a background queue
        DispatchQueue.global(qos: .default).async {
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: _varIB_mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:_varIB_mapView)
        }
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

                if let categorie = restaurantAnnotation.restaurant?.category {

                    switch categorie {

                    case CategorieRestaurant.Vegan :
                        pinView?.image = Asset.imgAnotation0.image //  UIImage(asset: .Img_anotation_0)

                    case CategorieRestaurant.Végétarien :
                        pinView?.image = Asset.imgAnotation1.image //UIImage(asset: .Img_anotation_1)

                    case CategorieRestaurant.VeganFriendly :
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

        let label_info = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label_info.font = UIFont(name: "URWGothicL-Book", size: 12)!
        label_info.textAlignment = .left
        label_info.text = "Plus d'informations"
        label_info.textColor = UIColor.black

        view_support.addSubview(label_info)

        let tapReconizer = UITapGestureRecognizer(target: self, action: #selector(MapsViewController.touch_bt_more_info(sender:)))
        view_support.addGestureRecognizer(tapReconizer)
        view_support.tag = currentAnnotation.restaurant?.identifier?.intValue ?? 0

    }

    func touch_bt_more_info(sender: UITapGestureRecognizer) {

        if let ident = sender.view?.tag, ident > 0 {

                for currentRestaurant in self.clusteringManager.allAnnotations().flatMap({ (annotation) -> Restaurant? in

                        return (annotation as? RestaurantAnnotation)?.restaurant

                }) where  (currentRestaurant.identifier?.intValue ?? -1) == ident {

                         self.performSegue(withIdentifier: StoryboardSegue.Main.segueToDetail.rawValue, sender : currentRestaurant )

                    break

                }
        }
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
        UserLocationManager.shared.getLocation().then { (location) -> Void in
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.varIB_mapView?.setRegion(region, animated: true)
        }
    }

    override func updateData() {
        AnalyticsHelper.shared.eventRestaurantList(categories: enabledCategories, listType: "map", hasLocation: UserLocationManager.shared.location != nil)

        let annotations = UserData.shared.viewContext.getRestaurants().filter({ (restaurant: Restaurant) -> Bool in
            if self.filtre_categorie_VeganFriendly_active && self.filtre_categorie_Vegetarien_active && self.filtre_categorie_Vegan_active {
                return true
            } else {
                switch restaurant.category {
                case CategorieRestaurant.Vegan :
                    if self.filtre_categorie_Vegan_active {
                        return true
                    }
                case CategorieRestaurant.Végétarien :
                    if self.filtre_categorie_Vegetarien_active {
                        return true
                    }
                case CategorieRestaurant.VeganFriendly :
                    if self.filtre_categorie_VeganFriendly_active {
                        return true
                    }
                }
                return false
            }
        }).flatMap({ (restaurant: Restaurant) -> FBAnnotation? in
            guard let lat = restaurant.lat?.doubleValue,
                  let lon = restaurant.lon?.doubleValue,
                  (restaurant.radius?.doubleValue ?? 0) == 0 else {
                return nil
            }

            let current_pin = RestaurantAnnotation(_restaurant : restaurant)
            current_pin.coordinate = CLLocationCoordinate2D(latitude:  lat, longitude: lon)
            return current_pin
        })

        if let _varIB_mapView = self.varIB_mapView {
            clusteringManager.setAnnotations(annotations: annotations)

            let mapBoundsWidth = Double(_varIB_mapView.bounds.size.width)
            let mapRectWidth: Double = _varIB_mapView.visibleMapRect.size.width
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: _varIB_mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:_varIB_mapView)
        }
    }
}
