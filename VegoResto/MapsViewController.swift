//
//  MapsViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 30/03/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift
import SVPulsingAnnotationView

class MapsViewController: UIViewController, MKMapViewDelegate {

    let clusteringManager = FBClusteringManager()

    @IBOutlet weak var varIB_mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()


        var array: [FBAnnotation] = [FBAnnotation]()

        for restaurant in UserData.sharedInstance.getRestaurants() {

            if let lat = restaurant.lat, lon = restaurant.lon {

                let current_pin = RestaurantAnnotation(_restaurant : restaurant)

                current_pin.coordinate = CLLocationCoordinate2D(latitude:  Double(lat), longitude: Double(lon) )
                array.append(current_pin)
            }
        }

        clusteringManager.addAnnotations(array)


        self.varIB_mapView.showsUserLocation = true

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock({
            let mapBoundsWidth = Double(self.varIB_mapView.bounds.size.width)
            let mapRectWidth: Double = self.varIB_mapView.visibleMapRect.size.width
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.varIB_mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.varIB_mapView)
        })
    }


    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        var reuseId = ""

        if annotation.isKindOfClass(FBAnnotationCluster) {

            reuseId = "Cluster"

            let clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            clusterView.backgroundColor = UIColor.redColor()

            return clusterView

        } else if annotation.isKindOfClass(RestaurantAnnotation) {

            reuseId = "myIdentifier"

            var pinView: MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)

            if pinView == nil {

                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)

                pinView?.canShowCallout = true

            }




            if let restaurantAnnotation = annotation as? RestaurantAnnotation {

                let myView = UIView()
                myView.backgroundColor = UIColor.clearColor()

                let widthConstraint = NSLayoutConstraint(item: myView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 220)
                myView.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: myView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 80)
                myView.addConstraint(heightConstraint)

                myView.frame.size = CGSize(width: 220, height: 80)

                self.configurerViewAnnotation( myView, currentAnnotation: restaurantAnnotation )

                pinView?.detailCalloutAccessoryView = myView

                if let categorie = restaurantAnnotation.restaurant?.categorie() {

                switch categorie {

                case CategorieRestaurant.Vegan :
                    pinView?.image = UIImage.Asset.Img_anotation_0.image

                case CategorieRestaurant.Végétarien :
                    pinView?.image = UIImage.Asset.Img_anotation_1.image

                case CategorieRestaurant.Traditionnel :
                    pinView?.image = UIImage.Asset.Img_anotation_2.image

                }
                }


            }








            pinView?.frame.size = CGSize(width: 144.0/4.0, height: 208.0/4.0)

            pinView?.centerOffset = CGPoint(x : 0, y : -(pinView!.frame.size.height*0.5) )



            return pinView

        } else {


            reuseId = "currentLocation"

            var pulsingView: SVPulsingAnnotationView? =  mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? SVPulsingAnnotationView

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
        layer_barre_separation.backgroundColor = UIColor.grayColor().CGColor

        view_support.layer.addSublayer(layer_barre_separation)

        position_y += largeur_barre_separation + espacement_y

        let label_adresse: UILabel = UILabel(frame: CGRect( x : 0, y : position_y, width : view_width, height : hauteur_label_adresse ) )
        label_adresse.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        label_adresse.numberOfLines = 2
        label_adresse.text = currentAnnotation.restaurant?.address
        view_support.addSubview(label_adresse)

        position_y += hauteur_label_adresse  + espacement_y

        let image_label1: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label1.image =  UIImage.Asset.Img_ic_phone_black.image
        view_support.addSubview(image_label1)


        let label1: UILabel = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label1.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        view_support.addSubview(label1)

        label1.text = currentAnnotation.restaurant?.phone

        position_y += img_width  + espacement_y

        let image_label2: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label2.image = UIImage.Asset.Img_ic_more_black.image
        view_support.addSubview(image_label2)

        let bt_info = BTTransitionVersDetailsRestaurant(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        bt_info.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        bt_info.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        bt_info.setTitle("Plus d'informations", forState: UIControlState.Normal)
        bt_info.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        bt_info.restaurant = currentAnnotation.restaurant
        bt_info.addTarget(self, action: #selector(MapsViewController.touch_bt_more_info(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view_support.addSubview(bt_info)



    }

    func touch_bt_more_info(sender: BTTransitionVersDetailsRestaurant) {

         self.performSegue(StoryboardSegue.Main.Segue_to_detail)
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    switch StoryboardSegue.Main(rawValue: segue.identifier! )! {

        case .Segue_to_detail:
        // Prepare for your custom segue transition

            if let detailRestaurantVC: DetailRestaurantViewController = segue.destinationViewController as? DetailRestaurantViewController {

                if let restaurantCible = sender as? Restaurant {

                    detailRestaurantVC.current_restaurant = restaurantCible
                }

            }
        }



    }




    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {


        if let annotation = view.annotation {

            if annotation.isKindOfClass(FBAnnotationCluster) {

            } else if annotation.isKindOfClass(RestaurantAnnotation) {

                //if let restaurantAnnotation = annotation as? RestaurantAnnotation {

                //}

            }

        }


    }


    // permet de conserver l'annotation de la position de l'user toujours au dessus des autres (Z-Index).
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {

        for view: MKAnnotationView in views {
            if let annotation = view.annotation {

                if annotation.isKindOfClass(MKUserLocation) {
                    view.superview?.bringSubviewToFront(view)
                } else {
                    view.superview?.sendSubviewToBack(view)
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


}



class BTTransitionVersDetailsRestaurant: UIButton {

    var restaurant: Restaurant? = nil

}
