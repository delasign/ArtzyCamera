//
//  AppVariables.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import UIKit

var artzyNotificationView:NotificationView      = NotificationView();
var artzyNotificationBlimp:NotificationBlimp    = NotificationBlimp();

var screenWidth:CGFloat                         = CGFloat();
var screenHeight:CGFloat                        = CGFloat();

var kArtzyNotificationRect:CGRect               = CGRect();
var kArtzMinYLabelLine:CGFloat                  = CGFloat();

var kArtzyBlimpDimension:CGFloat                = CGFloat();
var kArtzyBlimpBaseRect:CGRect                  = CGRect();

var kArtzyNotificationLabelRect:CGRect          = CGRect();

var kArtzyCameraButtonDimension:CGFloat         = CGFloat();
var kArtzyCameraButtonMinY:CGFloat              = CGFloat();

var kArtzyResetButtonDimension:CGFloat          = CGFloat();
var kArtzyResetButtonMinY:CGFloat               = CGFloat();


var kArtzyHUDButtonGap:CGFloat                  = CGFloat();
var kArtzyHUDButtonDimension:CGFloat            = CGFloat();
var kArtzyHUDButtonMinY:CGFloat                 = CGFloat();


public func instantiateArtzyVariables() {

    kArtzyHUDButtonDimension = 0.15*screenWidth;
    kArtzyHUDButtonGap = 0.048*screenWidth;
    kArtzyHUDButtonMinY = kArtzyCameraButtonMinY-kArtzyHUDButtonDimension-kArtzyHUDButtonGap;

    kArtzyCameraButtonDimension = screenWidth*0.2;
    kArtzyCameraButtonMinY = screenHeight*0.9-kArtzyCameraButtonDimension;
    
    kArtzyResetButtonDimension = screenWidth*0.125;
    kArtzyResetButtonMinY = screenHeight*0.05+kArtzyHUDButtonGap/2
    
    kArtzyNotificationRect = CGRect(x: screenWidth*0.25, y: 0, width: screenWidth*0.5, height: screenHeight*0.2)
    kArtzMinYLabelLine = screenHeight*0.0625
    
    kArtzyBlimpDimension = screenHeight*0.025;
    
    kArtzyBlimpBaseRect = CGRect(x: 0, y: kArtzMinYLabelLine, width: kArtzyBlimpDimension, height: kArtzyBlimpDimension)
    
    kArtzyNotificationLabelRect = CGRect(x: kArtzyBlimpDimension, y: kArtzMinYLabelLine, width: kArtzyNotificationRect.width-kArtzyBlimpDimension, height: kArtzyNotificationRect.height);
}
