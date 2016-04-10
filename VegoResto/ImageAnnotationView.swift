//
//  ImageAnnotationView.swift
//  
//
//  Created by Laurent Nicolas on 09/04/2016.
//
//

import UIKit
import MapKit


class ImageAnnotationView: MKAnnotationView {
    
    var annotationImageView: UIImageView!
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.bounds = CGRectMake(0, 0, 56, 56)
        self.backgroundColor = UIColor.clearColor()
        
        annotationImageView = UIImageView(frame: bounds)
        annotationImageView.layer.cornerRadius = 28
        annotationImageView.layer.masksToBounds = true
        annotationImageView.backgroundColor = UIColor.blueColor()
        self.addSubview(annotationImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}