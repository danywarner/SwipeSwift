//
//  DraggableView.swift
//  swipeswift
//
//  Created by Daniel Warner on 12/28/15.
//  Copyright © 2015 Daniel Warner. All rights reserved.
//

import Foundation
import UIKit

protocol DraggableViewDelegate {
    // The following command (ie, method) must be obeyed by any
    // underling (ie, delegate) of the older sibling.
    func cardSwipedLeft(card: UIView)
    func cardSwipedRight(card: UIView)
}

class DraggableView: UIView{
    
    var overlayView: OverlayView!
    var xFromCenter: CGFloat!
    var yFromCenter: CGFloat!
    var originalPoint: CGPoint!
    var delegate: DraggableViewBackground!
    var information: UILabel!
    let ACTION_MARGIN: CGFloat = 120
    let SCALE_STRENGTH: CGFloat = 4
    let SCALE_MAX: CGFloat = 0.93
    let ROTATION_MAX: CGFloat = 1
    let ROTATION_STRENGTH: CGFloat = 320
    let ROTATION_ANGLE: CGFloat = CGFloat(M_PI / 8.0)
    
   override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.setupView()
        information = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 100))
        information.text = "no info given"
        information.textAlignment = NSTextAlignment.Center
        information.textColor = UIColor.blackColor()
    
        self.backgroundColor = UIColor.whiteColor()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action:"beingDragged:")
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview(information)
    
        overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-100, 0, 100, 100))
        overlayView!.alpha = 0
        self.addSubview(overlayView)
    }
    
    
func setupView() {
    
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
        
}
    
    
    
func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
    
        xFromCenter = gestureRecognizer.translationInView(self).x
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch(gestureRecognizer.state) {
            case .Began:
                originalPoint = self.center
            
            case .Changed:
                let rotationStrength: CGFloat = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
                let rotationAngle = CGFloat(ROTATION_ANGLE * rotationStrength)
                let scale = max(CGFloat(1 - fabsf(Float(rotationStrength))) / SCALE_STRENGTH, SCALE_MAX)
                
                self.center = CGPointMake(originalPoint.x + xFromCenter, originalPoint.y + yFromCenter)
                let transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
                self.transform = scaleTransform
                self.updateOverlay(xFromCenter)
            
            case .Ended:
                self.afterSwipeAction()
            
            case .Possible:
                break
            case .Cancelled:
                break
            case .Failed:
                break
            default:
                break
        }
    }
    
    func updateOverlay(distance: CGFloat) {
        if distance > 0 {
            overlayView.mode = OverlayView.CGOverlayViewMode.GGOverlayViewModeRight
        } else {
            overlayView.mode = OverlayView.CGOverlayViewMode.GGOverlayViewModeLeft
        }
        
        overlayView.alpha = min(CGFloat(fabsf(Float(distance))/100), CGFloat(0.4))
    }
    
    func afterSwipeAction() {
        if xFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if xFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() {
        let finishPoint: CGPoint = CGPointMake(500, 2*yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
        print("YES")
    }

    func leftAction() {
        let finishPoint: CGPoint = CGPointMake(-500, 2*yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
        print("NO")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
}