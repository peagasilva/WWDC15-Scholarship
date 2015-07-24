//
//  UIViewExtensions.swift
//  RaphaelSilva
//
//  Created by Raphael Silva on 4/16/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - Frame
    
    /**
    Redefines X position of the view
    
    :param: x The new x-coordinate of the view's origin point
    */
    func setX(x: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.origin.x = x
        
        self.frame = frame
    }

    /**
    Redefines Y position of the view
    
    :param: y The new y-coordinate of the view's origin point
    */
    func setY(y: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.origin.y = y
        
        self.frame = frame
    }

    /**
    Redefines the width of the view
    
    :param: width The new value for the view's width
    */
    func setWidth(width: CGFloat) {
        
        var frame: CGRect = self.frame
        frame.size.width = width
        
        self.frame = frame
    }
    
    /**
    Redefines the height of the UIVIew
    
    :param: height The new value for the view's height
    */
    func setHeight(height: CGFloat) {
        
        var frame: CGRect = self.frame
        
        frame.size.height = height
        
        self.frame = frame
    }
    
    // MARK: - Animations
    
    /**
    Creates a Fade-in animation for the view
    */
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = { (finished: Bool) -> Void in }) {
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.alpha = 1.0
            
        }, completion: completion)
    }
    
    /**
    Creates a Fade-out animation for the view
    */
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = { (finished: Bool) -> Void in }) {
        
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.alpha = 0.0
            
        }, completion: completion)
    }
    
    // MARK: - Blur in background
    
    /**
    Creates a blur effect in the view's background
    
    :param: style The UIBlurEffectStyle desired
    */
    func blurBackground(style: UIBlurEffectStyle) {

        let imageView = UIImageView()
        
        imageView.frame = self.frame
        
        var blur:UIBlurEffect = UIBlurEffect(style: style)
        var effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        
        effectView.frame = imageView.frame
        
        imageView.addSubview(effectView)
        
        self.addSubview(imageView)
    }
    
    // MARK: - Revome elements methods
    
    /**
    Removes all subviews from the view
    */
    func revomeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}