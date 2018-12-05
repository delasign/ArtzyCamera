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

var kArtzyBlimpDimension:CGFloat                = CGFloat();
var kArtzyBlimpMinY:CGFloat                     = CGFloat();
var kArtzyBlimpBaseRect:CGRect                  = CGRect();

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
    
    kArtzyBlimpDimension = screenHeight*0.025;
    kArtzyBlimpMinY = kArtzyResetButtonMinY*0.35
    kArtzyBlimpBaseRect = CGRect(x: 0, y: kArtzyBlimpMinY, width: kArtzyBlimpDimension, height: kArtzyBlimpDimension)
}
