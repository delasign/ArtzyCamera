//
//  NotificationBlimp.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/4/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit

class NotificationBlimp: UIView {
    
    let flash = CABasicAnimation(keyPath: "opacity")
    var previousState:ArtzyNotificationStyle = .searching;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.layer.backgroundColor = UIColor.white.cgColor;
        self.layer.cornerRadius = self.frame.width/2;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public func updateNotificationStyle(style:ArtzyNotificationStyle) {
        
        print("STYLE : \(style)")
        
        switch style {
        case .searching:
            self.previousState = .searching
            self.blink()
            break
        case .preview:
            self.hide()
            break
        case .itemFound:
            self.previousState = .itemFound
            self.greenLight()
            break
        case .error:
            self.previousState = .error
            self.redLight()
            break
        case .previous:
            self.updateNotificationStyle(style: self.previousState)
            break
        default:
            // Error
            break
        }
        
    }
   
    private func redLight() {
        self.removeBlink();
        self.alpha = 1;
        self.layer.backgroundColor = UIColor.red.cgColor;
    }
    
    private func greenLight() {
        self.removeBlink();
        self.alpha = 1;
        self.layer.backgroundColor = UIColor.green.cgColor;
    }
    
    private func hide() {
        self.removeBlink();
        self.alpha = 0;
    }
    
    
    
    private func blink() {
        self.alpha = 1;
        
        flash.duration = 1.33
        flash.fromValue = 1 // alpha
        flash.toValue = 0 // alpha
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = HUGE;
        
        layer.add(flash, forKey: nil)
    }
    
    private func removeBlink() {
        layer.removeAllAnimations()
    }
    
}
