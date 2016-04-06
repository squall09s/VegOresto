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
        
        
        
        
        
        var array : [FBAnnotation] = [FBAnnotation]()
        
        for restaurant in UserData.sharedInstance.getRestaurants()  {
            
            if let lat = restaurant.lat , lon = restaurant.lon{
                
                let current_pin = RestaurantAnnotation(_titre: restaurant.name, _telephone: restaurant.phone, _url: restaurant.absolute_url, _adresse: restaurant.address, _tag: [Tag]() )
                
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
    
    
    
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        NSOperationQueue().addOperationWithBlock({
            let mapBoundsWidth = Double(self.varIB_mapView.bounds.size.width)
            let mapRectWidth:Double = self.varIB_mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.varIB_mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.varIB_mapView)
        })
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        if annotation.isKindOfClass(FBAnnotationCluster) {
            
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            return clusterView
            
        } else if annotation.isKindOfClass(RestaurantAnnotation)  {
            
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = UIColor.greenColor()
            
            pinView!.canShowCallout = true
            pinView!.animatesDrop = false
            
            
            let myView = UIView()
            myView.backgroundColor = .greenColor()
            
            let widthConstraint = NSLayoutConstraint(item: myView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 150)
            myView.addConstraint(widthConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: myView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 50)
            myView.addConstraint(heightConstraint)
            
            pinView!.detailCalloutAccessoryView = myView
            
            return pinView
        
        }else {
            
                
            print("current ici ")
                
            reuseId = "currentLocation"
            
            var pulsingView : SVPulsingAnnotationView? =  mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? SVPulsingAnnotationView
    
            if pulsingView == nil{
                
                pulsingView = SVPulsingAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pulsingView!.annotationColor = UIColor(red: 0.678431, green: 0.0, blue: 0.0, alpha: 1.0)
                pulsingView!.canShowCallout = true
            
            }
        
            return pulsingView
        
    }
    
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        
        if let annotation = view.annotation {
            
            if annotation.isKindOfClass(FBAnnotationCluster) {
                
            }else if annotation.isKindOfClass(RestaurantAnnotation) {
                
                //if let restaurantAnnotation = annotation as? RestaurantAnnotation {
                
                    
                
                //}
                
            }
            
        }
            
    
    }
    
    
    
    
    @IBAction func touch_bt_location(sender: AnyObject) {
        
        if let location = UserData.sharedInstance.location{
        
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.varIB_mapView.setRegion(region, animated: true)
            
        }
    }
     
    
    
}



