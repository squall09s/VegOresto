//
//  UIView+Material.swift
//  Pumpkin-v3
//
//  Created by Nicolas on 03/10/2017.
//  Copyright © 2017 Victor Lennel. All rights reserved.
//

import UIKit

let UIViewMaterialDesignTransitionDurationCoeff: TimeInterval = 0.65

extension UIView {

    static func mdInflateTransitionFromView( fromView: UIView, toView: UIView, originalPoint: CGPoint, duration: TimeInterval, completion: ( () -> Void )? ) {

        if let containerView = fromView.superview {

            let convertedPoint: CGPoint = fromView.convert(originalPoint, to: fromView)
            containerView.layer.masksToBounds = true

            let animationHandler: (() -> Void) = {
                toView.alpha = 0.0
                toView.frame = fromView.frame
                containerView.addSubview(toView)
                fromView.removeFromSuperview()

                let animationDuration: TimeInterval = (duration - duration * UIViewMaterialDesignTransitionDurationCoeff)
                UIView.animate(withDuration: animationDuration, animations: { toView.alpha = 1.0 },
                               completion: { (_) in
                                completion?()
                })
            }

            containerView.mdAnimateAtPoint(point: convertedPoint, backgroundColor: toView.backgroundColor ?? UIColor.black,
                                           duration: duration * UIViewMaterialDesignTransitionDurationCoeff, inflating: true,
                                           zTopPosition: true, shapeLayer: nil, completion: animationHandler)

        } else {
            completion?()
        }

    }

    static func mdDeflateTransitionFromView(fromView: UIView, toView: UIView, originalPoint: CGPoint, duration: TimeInterval, completion : ( () -> Void )? ) {

        if let containerView = fromView.superview {

            containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = fromView.frame

            // convert point into container view coordinate system
            let convertedPoint: CGPoint = toView.convert(originalPoint, to: fromView)

            // insert layer
            let layer: CAShapeLayer = toView.mdShapeLayerForAnimationAtPoint(point: convertedPoint)
            layer.fillColor = fromView.backgroundColor?.cgColor
            toView.layer.addSublayer(layer)
            toView.layer.masksToBounds = true

            // hide fromView
            let animationDuration: TimeInterval = (duration - duration * UIViewMaterialDesignTransitionDurationCoeff)

            UIView.animate(withDuration: animationDuration, animations: {

                fromView.alpha = 0.0

            }, completion: { (_) in

                toView.mdAnimateAtPoint(point: convertedPoint, backgroundColor: fromView.backgroundColor ?? UIColor.black,
                                        duration: duration * UIViewMaterialDesignTransitionDurationCoeff, inflating: false,
                                        zTopPosition: true, shapeLayer: layer, completion: completion)

            })

        } else {
            completion?()

        }

    }

    func mdInflateAnimatedFromPoint(point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, completion : ( () -> Void )? ) {

        self.mdAnimateAtPoint(point: point, backgroundColor: backgroundColor, duration: duration, inflating: true, zTopPosition: false, shapeLayer: nil, completion: completion)

    }

    func mdDeflateAnimatedToPoint(point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, completion : ( () -> Void )? ) {

        self.mdAnimateAtPoint(point: point, backgroundColor: backgroundColor, duration: duration, inflating: false, zTopPosition: false, shapeLayer: nil, completion: completion)

    }

    func mdShapeDiameterForPoint(point: CGPoint ) -> CGFloat {

        let cornerPoints: [CGPoint] = [ CGPoint(x: 0, y: 0),
                                         CGPoint(x: 0, y: self.bounds.size.height),
                                         CGPoint(x: self.bounds.size.width, y: self.bounds.size.height),
                                         CGPoint(x: self.bounds.size.width, y: 0) ]

        var radius: CGFloat = 0.0

        for i in 0...(cornerPoints.count - 1) {

            let p: CGPoint = cornerPoints[i]
            let d: CGFloat = sqrt( pow(p.x - point.x, 2.0) + pow(p.y - point.y, 2.0) )

            if d > radius {
                radius = d
            }
        }

        return radius * 2.0
    }

    func mdShapeLayerForAnimationAtPoint(point: CGPoint) -> CAShapeLayer {

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let diameter: CGFloat = self.mdShapeDiameterForPoint(point: point)
        shapeLayer.frame = CGRect(x: floor(point.x - diameter * 0.5), y: floor(point.y - diameter * 0.5), width: diameter, height: diameter)
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter) ).cgPath

        return shapeLayer
    }

    func shapeAnimationWithTimingFunction(timingFunction: CAMediaTimingFunction, scale: CGFloat, inflating: Bool) -> CABasicAnimation {

        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")

        if inflating {
            animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
            animation.fromValue = NSValue.init(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
        } else {
            animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(scale, scale, 1.0))
            animation.fromValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))
        }
        animation.timingFunction = timingFunction
        animation.isRemovedOnCompletion = true

        return animation

    }

    func mdAnimateAtPoint(point: CGPoint, backgroundColor: UIColor, duration: TimeInterval, inflating: Bool, zTopPosition: Bool, shapeLayer: CAShapeLayer?, completion : ( () -> Void )? ) {

        let shapeLayer = self.mdShapeLayerForAnimationAtPoint(point: point)
        // create layer
        self.layer.masksToBounds = true

        if zTopPosition {
            self.layer.addSublayer(shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        if inflating == false {
            shapeLayer.fillColor = self.backgroundColor?.cgColor
            self.backgroundColor = backgroundColor
        } else {
            shapeLayer.fillColor = backgroundColor.cgColor
        }

        // animate
        let scale: CGFloat = 1.0 / shapeLayer.frame.size.width
        let timingFunctionName: String = kCAMediaTimingFunctionDefault
        let animation: CABasicAnimation = self.shapeAnimationWithTimingFunction(timingFunction: CAMediaTimingFunction(name: timingFunctionName), scale: scale, inflating: inflating)

        animation.duration = duration
        if let anim = (animation.toValue as? NSValue)?.caTransform3DValue {
            shapeLayer.transform = anim
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {

            if inflating {
                self.backgroundColor = backgroundColor
            }
            shapeLayer.removeFromSuperlayer()

            completion?()
        }
        shapeLayer.add(animation, forKey: "shapeBackgroundAnimation")
        CATransaction.commit()

    }

}
