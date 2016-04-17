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

                let current_pin = RestaurantAnnotation(_titre: restaurant.name,
                                                       _telephone: restaurant.phone,
                                                       _url: restaurant.absolute_url,
                                                       _adresse: restaurant.address,
                                                       _tag: [Tag]() )

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
                //pinView?.animatesDrop = false

            }




            if let restaurantAnnotation = annotation as? RestaurantAnnotation {

                let myView = UIView()
                myView.backgroundColor = UIColor.clearColor()

                let widthConstraint = NSLayoutConstraint(item: myView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 220)
                myView.addConstraint(widthConstraint)

                let heightConstraint = NSLayoutConstraint(item: myView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 90)
                myView.addConstraint(heightConstraint)

                myView.frame.size = CGSize(width: 220, height: 90)

                self.configurerViewAnnotation( myView, currentAnnotation: restaurantAnnotation )

                pinView?.detailCalloutAccessoryView = myView
            }





            pinView?.image = UIImage(named: "img_anotation")

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
        let espacement_y: CGFloat = 2.0
        let espacement_x: CGFloat = 5.0

        let hauteur_label_adresse: CGFloat = 23.0

        let view_width = view_support.frame.size.width

        var position_y: CGFloat = 0

        let layer_barre_separation: CALayer = CALayer()
        layer_barre_separation.frame = CGRect( x : view_width * 0.1, y : position_y, width : view_width * 0.8, height : largeur_barre_separation )
        layer_barre_separation.backgroundColor = UIColor.grayColor().CGColor

        view_support.layer.addSublayer(layer_barre_separation)

        position_y += largeur_barre_separation + espacement_y

        let label_adresse: UILabel = UILabel(frame: CGRect( x : 0, y : position_y, width : view_width, height : hauteur_label_adresse ) )
        label_adresse.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        label_adresse.numberOfLines = 2
        label_adresse.text = currentAnnotation.adresse
        view_support.addSubview(label_adresse)

        position_y += hauteur_label_adresse  + espacement_y

        let image_label1: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label1.image = UIImage(named: "img_ic_phone_black")
        view_support.addSubview(image_label1)


        let label1: UILabel = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label1.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        view_support.addSubview(label1)

        position_y += img_width  + espacement_y

        let image_label2: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label2.image = UIImage(named: "img_ic_maps_black")
        view_support.addSubview(image_label2)

        let label2: UILabel = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label2.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        view_support.addSubview(label2)

        position_y += img_width  + espacement_y

        let image_label3: UIImageView = UIImageView(frame: CGRect( x : 0, y : position_y, width : img_width, height : img_width) )
        image_label3.image = UIImage(named: "img_ic_more_black")

        view_support.addSubview(image_label3)

        let label3: UILabel = UILabel(frame: CGRect( x : img_width + espacement_x, y : position_y, width : view_width - img_width - espacement_x, height : img_width) )
        label3.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        view_support.addSubview(label3)


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
